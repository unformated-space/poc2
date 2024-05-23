extends Herramienta


func change_block(raycast_end):
	var block_library = load("res://grid_system/block_library.tscn").instantiate()
	#var raycast_end = get_tree().get_node("Player/Player/CameraController/pivot/interact_raycast/raycastEnd")
	for i in block_library.get_child_count():
		if Globals.active_item == i and raycast_end:
			for j in raycast_end.get_child_count():
				raycast_end.get_child(j).queue_free()
			var display_block = load(block_library.get_child(i).scene_file_path)
			var for_display = display_block.instantiate()
			qwe.l(for_display.get_script())
			for child in for_display.get_children():
				#qwe.l(child)
				if child.get_script():
					for_display.set_script("")
					if child.has_method ("get_collision_mask_value"):
						child.set_collision_mask_value(9)
				for child_in_child in child.get_children():
					if child.get_script():
						child_in_child.set_script("")
			#qwe.l(for_display)
			qwe.l(for_display.get_script())
			for_display.set_script(load("res://grid_system/snapping.gd"))
			qwe.l(for_display.get_script())

			raycast_end.add_child(for_display)
			#qwe.l(raycast_end.get_children())
			return
