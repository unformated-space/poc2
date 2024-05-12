class_name Block
extends Interactable
@onready var mesh = $mesh

#@onready var grid_container = $"."

var initial_hit_normal = Vector3.ZERO
var initial_object = Object
func _interact_right(hit_normal, hit_point, collided_object):
	print ("interacted?")
	add_block( hit_normal,hit_point,collided_object)

#func _interact_left(_position, collided_object):
	#remove_block(BASE_STATIC, _position,collided_object)
	#

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	if parent.name == "_grids":
		print ("onready")
		var _grid_Instance = load("res://grid_system2/Grid.tscn").instantiate()
		var UUID = "UUID"+str(ResourceUID.create_id())
		_grid_Instance.name=UUID
		parent.add_child(_grid_Instance)
		var _grid = get_node("/root/world/_grids/"+UUID+"/grid_body")
		var grid_area = get_node("/root/world/_grids/"+UUID+"/grid_area")


		#var area_mesh = MeshInstance3D.new()
		#area_mesh.mesh = mesh.mesh
		#var area_collision_shape = CollisionShape3D.new()
		#area_collision_shape.set_shape (mesh.mesh.create_convex_shape())
		#area_collision_shape.name = "area_body_collision"
		#area_mesh.mesh = mesh.mesh
		#area_mesh.set_layer_mask_value(1, false)
		#area_mesh.set_layer_mask_value(2, true)
		#area_mesh.name= "area_body_mesh"
#
		#grid_area.add_child(area_collision_shape)
		#grid_area.add_child(area_mesh)
		#area_mesh.global_transform = global_transform
		#grid_area.global_transform = global_transform

		#print (grid_area.get_children())
		#print(grid_area.name)
		#grid_area.global_transform = global_transform
		
		#collision adding 
		var grid_mesh = MeshInstance3D.new()
		var collision_shape = CollisionShape3D.new()
		collision_shape.set_shape (mesh.mesh.create_convex_shape())
		collision_shape.name = "grid_body_collision"
		grid_mesh.mesh = mesh.mesh
		grid_mesh.name= "grid_body_mesh"
		
		#random color
		var material = StandardMaterial3D.new()
		material.albedo_color = random_color()
		grid_mesh.material_override = material

		_grid.add_child(collision_shape)
		_grid.add_child(grid_mesh)
		_grid.global_transform = global_transform
		name="area_from_(0,0,0)"
		
		reparent(_grid, true)



func debugger(args):
	var result = ""
	for arg in args:
		result += " "+str(arg)
	DebugConsole.log(result)
#
#hit_normal contanis the get_collision_normal of a raycast
#hit_point contanis the get_collision_point of a raycast

func add_block(hit_normal,hit_point,collided_object, interact=true):
	const BASE_STATIC = "res://grid_system2/Block.tscn"
	var grid_container = get_parent()
	print ("entre aca")
	var grid_size =Vector3(0.5, 0.5, 0.5) #en metros
	#var grid_size =Vector3(1, 1, 1)
	# Compute the grid position based on block size
	var new_block_position = collided_object.transform.origin + (hit_point * grid_size)
	debugger([new_block_position, collided_object.transform.origin , hit_normal,  (hit_normal * grid_size)])
	# Check if there is already a block at this position (optional, depending on your design)
	for child in grid_container.get_children():
		if child.global_transform.origin == new_block_position:
			return # Block already exists at this positiondw

	# Instance the block
	var new_block_instance = load(BASE_STATIC).instantiate()
	new_block_instance.name = "area_from_"+str(new_block_position).replace(" ","")
	# Add the block instance to the current node or another parent node
	new_block_instance.transform.origin = new_block_position

	var block_collmesh = new_block_instance.get_node("collision")
	var block_mesh = new_block_instance.get_node("mesh")

	block_collmesh.name = "collision_from_"+str(collided_object.transform.origin).replace(" ","")

	#random color
	var material = StandardMaterial3D.new()
	material.albedo_color = random_color()
	block_mesh.material_override = material
	

	
	var grid_body = get_node(str(grid_container.get_path())+"/grid_body")
	grid_container.add_child(new_block_instance)
	var new_collision_for_body = CollisionShape3D.new()
	new_collision_for_body.set_shape (get_node(block_collmesh.get_path()).get_shape())
	new_collision_for_body.name = block_collmesh.name
	grid_body.add_child(new_collision_for_body)
	new_collision_for_body.global_transform = global_transform
	
	
## TODO: on remove block si se remueve 0.0.0 el rigid body se tiene q mover lo mejor seria q el rigid body no tenga volumen y se mueva siempre al centro de maza
func random_color():
	# Genera valores aleatorios para los componentes rojo, verde y azul
	var r = randf()  # Genera un número flotante aleatorio entre 0 y 1
	var g = randf()
	var b = randf()
	return Color(r, g, b, 1)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
