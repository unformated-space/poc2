extends Node3D

#
#static func create_grid(type_static, raycast ):
	#grid_type_static = type
	#used_raycast = raycast
	#
@export var coloreable : bool = true

#var used_raycast : RayCast3D
#var grid_type_static = false
var grids_scenes_path =  ["res://grid_system/Static_grid.tscn", "res://grid_system/Dynamic_grid.tscn"]
var block_path =  ["res://grid_system/Block.tscn", "res://grid_system/block_library/seat.tscn"]
# Called when the node enters the scene tree for the first time.
func create(grid_type_static, grid_position ):
	var new_grid_scene
	if grid_type_static:
		new_grid_scene = grids_scenes_path[0]
	else: 
		new_grid_scene = grids_scenes_path[1]
	var new_grid = load(new_grid_scene).instantiate()
	var UUID = "UUID"+str(ResourceUID.create_id())
	new_grid.name=UUID
	new_grid.position = grid_position
	add_child(new_grid)
	var first_block = load(block_path[Globals.active_item]).instantiate()
	var grid_mesh = MeshInstance3D.new()

	var first_block_mesh = first_block.get_node("mesh")
	grid_mesh.mesh = first_block_mesh.mesh
	grid_mesh.name= "grid_body_mesh"
	grid_mesh.set_layer_mask_value(1, false)
	grid_mesh.set_layer_mask_value(2, true)
	#position=grid_position.get_collision_normal()
	#
	if coloreable:
		var material = StandardMaterial3D.new()
		material.albedo_color = qwetool.random_color()
		grid_mesh.material_override = material
	
	new_grid.add_child(grid_mesh)
	#var new_collision_for_body = first_block.get_node("collision")
	var first_block_collision = first_block.get_node("collision")
	var new_collision_for_body = CollisionShape3D.new()
	new_collision_for_body.set_shape (first_block_collision.get_shape())
	new_collision_for_body.name = "collision_from_(0,0,0)"
	first_block_collision.name = "collision_from_(0,0,0)"
	new_collision_for_body.shape.margin=0
	new_grid.add_child(new_collision_for_body)
	first_block.name="area_from_(0,0,0)"
	new_grid.add_child(first_block)
	grid_mesh.set_layer_mask_value(1, false)
	grid_mesh.set_layer_mask_value(2, true)
