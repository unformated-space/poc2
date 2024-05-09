class_name Block
extends Area3D
@onready var mesh = $mesh


# Called when the node enters the scene tree for the first time.
func _ready():
	## FIXME: maybe initial configuration of grid on the block definition
	var parent = get_parent()
	if parent.get_class() == "Node3D":
		var _grid_Instance = load("res://grid_system2/Grid.tscn").instantiate()
		var UUID = "UUID"+str(ResourceUID.create_id())
		_grid_Instance.name=UUID
		parent.add_child(_grid_Instance)
		var _grid = get_node("/root/world/_grids/"+UUID+"/grid_body")
		var grid_mesh = MeshInstance3D.new()
		var collision_shape = CollisionShape3D.new()

		collision_shape.set_shape (mesh.mesh.create_convex_shape())
		collision_shape.name = "grid_body_collision"
		grid_mesh.mesh = mesh.mesh
		grid_mesh.name= "grid_body_mesh"
		_grid.add_child(collision_shape)
		_grid.add_child(grid_mesh)
		_grid.global_transform = global_transform
		reparent(_grid, true)
	else:
		print ("agregao")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
