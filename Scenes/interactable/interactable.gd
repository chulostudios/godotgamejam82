class_name InteractionComponent extends Node

@export var mesh : MeshInstance3D
@export_file("*.txt") var lore_file_path: String

var lore_text : String

var parent

var highlight_material = preload("res://Materials/interactable_highlight.tres")
#var outline_material = preload("res://Materials/outline.tres")
#
#var original_material : Material
#var outline_applied := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	connect_parent()
	set_default_mesh()
	
	#if mesh and mesh.get_surface_override_material(0):
		#original_material = mesh.get_surface_override_material(0)
	#else:
		#original_material = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_hover() -> void:
	mesh.material_overlay = highlight_material
	#apply_outline()

func on_unhover() -> void:
	mesh.material_overlay = null
	#remove_outline()

func on_interact() -> void:
	print(parent.name)

func connect_parent() -> void:
	parent.add_user_signal("hovering")
	parent.add_user_signal("unhovering")
	parent.add_user_signal("interacted")
	parent.connect("hovering", Callable(self, "on_hover"))
	parent.connect("unhovering", Callable(self, "on_unhover"))
	parent.connect("interacted", Callable(self, "on_interact"))

func set_default_mesh() -> void:
	if mesh: 
		pass
	else:
		for i in parent.get_children():
			if i is MeshInstance3D:
				mesh = i

#func apply_outline() -> void:
	#if mesh and not outline_applied:
		#var base_mat = mesh.get_surface_override_material(0)
		#if base_mat:
			#base_mat.next_pass = outline_material
		#outline_applied = true
#
#func remove_outline() -> void:
	#if mesh and outline_applied:
		#var base_mat = mesh.get_surface_override_material(0)
		#if base_mat:
			#base_mat.next_pass = null
		#outline_applied = false
