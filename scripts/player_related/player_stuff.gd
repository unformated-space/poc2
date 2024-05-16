#extends Node3D
#
### TODO: fis this sicrpt that born`s of i dont know how to sort stuff
#
#@onready var active_item_ui = get_node(Config.active_item_ui)
#@onready var interaction_raycast  = get_node(Config.interact_raycast)
#
#var mesh_index :=0
#var mesh_lenght := 0
#var wheel_timer := 0.0
#var move_direction := "" #false es hacia abajo true es hacia arriba
#func _ready():
	#active_item_ui.texture=mesh_lib.get_item_preview(0) # Add TextureRect to the container
	#mesh_lenght = mesh_lib.get_item_list().size()
#
	##for item_id in mesh_lib.get_item_list():
		##var icon_texture = mesh_lib.get_item_preview(item_id)
		##if icon_texture:
			##var texture_rect = TextureRect.new()
			##texture_rect.texture = icon_texture
#func _process(delta):
	#active_item_ui.texture=mesh_lib.get_item_preview(mesh_index)
	#Config.active_item=mesh_index
	#if (wheel_timer > 0.0):
		#wheel_timer += delta
	#if (wheel_timer > 0.5):
		#wheel_timer = 0.0
	#if move_direction != "":
		#if wheel_timer > 0.0 && wheel_timer < 0.4:
			#if move_direction == "fwd":
				#mesh_index +=1
				#move_direction = ""
			#else:
				#mesh_index -=1
				#move_direction = ""
	#mesh_index = wrapi(mesh_index, 0, mesh_lenght)
	#if interaction_raycast.is_colliding():
		#if Input.is_action_just_pressed("mouse_l_click"):
			#if interaction_raycast.get_collider().has_method("remove_block"):
				#interaction_raycast.get_collider().remove_block(interaction_raycast.get_collision_point() - interaction_raycast.get_collision_normal())
#
		#if Input.is_action_just_pressed("mouse_r_click"):
			#if interaction_raycast.get_collider().has_method("add_block"):
					#interaction_raycast.get_collider().add_block(interaction_raycast.get_collision_point() - interaction_raycast.get_collision_normal(), mesh_index)
#func _input(event): 
	#if event is InputEventMouseButton:
		#if event.button_index == 4:
			#move_direction = "dwn"
			#wheel_timer +=0.1
		#elif event.button_index == 5:
			#wheel_timer +=0.1
			#move_direction = "fwd"
