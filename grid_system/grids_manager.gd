extends Node3D

@export var coloreable : bool = true
var grids_scenes_path =  ["res://grid_system/Static_grid.tscn", "res://grid_system/Dynamic_grid.tscn"]
var block_path =  ["res://grid_system/Block.tscn", "res://grid_system/block_library/seat.tscn"]

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
