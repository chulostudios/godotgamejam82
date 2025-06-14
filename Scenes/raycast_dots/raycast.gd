extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot_rays"):

		print_debug("pressed")
		self.add_child($"./dot.tscn")

		# TODO: now we have to spread that shi out
		
		

	
