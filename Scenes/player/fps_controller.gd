class_name Player extends CharacterBody3D

@onready var CAM = %Camera3D

@export var look_sensitivity : float = 0.002
var current_rotation : float

#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 12.0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var interact_distace : float = 3.0
var interact_cast_result

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			current_rotation = -event.relative.x * look_sensitivity
			rotate_y(-event.relative.x * look_sensitivity) 
			CAM.rotate_x(-event.relative.y * look_sensitivity)
			CAM.rotation.x = clamp(CAM.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if event.is_action_pressed("interact"):
		interact()


func _process(delta: float)-> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forwards", "backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	interact_cast()

func interact_cast():
	var space_state = CAM.get_world_3d().direct_space_state
	var screen_center = get_viewport().size/2
	var origin = CAM.project_ray_origin(screen_center)
	var end = origin + CAM.project_ray_normal(screen_center) * interact_distace
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	var current_cast_result = result.get("collider")
	if current_cast_result != interact_cast_result:
		if interact_cast_result and interact_cast_result.has_user_signal("unhovering"):
			interact_cast_result.emit_signal("unhovering")
		interact_cast_result = current_cast_result
		if interact_cast_result and interact_cast_result.has_user_signal("hovering"):
			interact_cast_result.emit_signal("hovering")
	

func interact():
	if interact_cast_result and interact_cast_result.has_user_signal("interacted"):
		print("interactable object was hit")
		interact_cast_result.emit_signal("interacted")
