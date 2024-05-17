class_name Block
extends Interactable
@onready var mesh = $mesh
@onready var collision = $collision

@export var coloreable : bool = true
@export var thumbnail : Resource
#@onready var grid_container = $"."

var initial_hit_normal = Vector3.ZERO
var initial_object = Object
func _interact_right(hit_normal, hit_point, collided_object):
	#print ("interacted?")
	add_block( hit_normal,hit_point,collided_object)

func _interact_left(hit_normal, hit_point, collided_object):
	remove_block( hit_normal,hit_point,collided_object)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var grids_root = get_parent()
	if grids_root.name == "_grids":
		print ("onready")
		var new_grid_container = load("res://grid_system/Grid.tscn").instantiate()
		var UUID = "UUID"+str(ResourceUID.create_id())
		new_grid_container.name=UUID
		new_grid_container.position = initial_hit_normal
		grids_root.add_child(new_grid_container)
		position=initial_hit_normal

		var grid_body = get_node("/root/world/_grids/"+UUID+"/grid_body")
	
		##collision adding 
		var grid_mesh = MeshInstance3D.new()
		grid_mesh.mesh = mesh.mesh
		grid_mesh.name= "grid_body_mesh"
		grid_mesh.set_layer_mask_value(1, false)
		grid_mesh.set_layer_mask_value(2, true)
		#random color
		if coloreable:
			var material = StandardMaterial3D.new()
			material.albedo_color = random_color()
			mesh.material_override = material
		
		new_grid_container.add_child(grid_mesh)
		
		var new_collision_for_body = CollisionShape3D.new()
		new_collision_for_body.set_shape (collision.get_shape())
		new_collision_for_body.name = "collision_from_(0,0,0)"
		new_collision_for_body.shape.margin=0
		new_grid_container.add_child(new_collision_for_body)



		mesh_instance_3d=mesh
		name="area_from_(0,0,0)"
		mesh.set_layer_mask_value(1, false)
		mesh.set_layer_mask_value(2, true)
		reparent(new_grid_container, true)



func debugger(args):
	var result = ""
	for arg in args:
		result += " "+str(arg)
	DebugConsole.log(result)
#
#hit_normal contanis the get_collision_normal of a raycast
#hit_point contanis the get_collision_point of a raycast
func snapped_to_grid(position: Vector3) -> Vector3:
	var grid_size = Vector3(0.5, 0.5, 0.5)
	return Vector3(
		floor(position.x / grid_size.x) * grid_size.x,
		floor(position.y / grid_size.y) * grid_size.y,
		floor(position.z / grid_size.z) * grid_size.z
	)
	
func add_block(hit_normal,hit_point,collided_object):
	var grid_container = get_parent()
	var grid_size =Vector3(0.5, 0.5, 0.5) #en metros
	#var grid_size =Vector3(1, 1, 1)
	# Compute the grid position based on block size
	var new_block_position = collided_object.transform.origin + (hit_normal.snapped(grid_size)*grid_size)
	# Check if there is already a block at this position (optional, depending on your design)
	for child in grid_container.get_children():
		if child.transform.origin == new_block_position:
			DebugConsole.log("already here "+child.name)
			return # Block already exists at this positiondw

	# Instance the block
	var new_block_instance = load("res://grid_system/Block.tscn").instantiate()
	new_block_instance.name = "area_from_"+str(new_block_position).replace(" ","")
	# Add the block instance to the current node or another parent node
	new_block_instance.transform.origin = new_block_position

	var block_collmesh = new_block_instance.get_node("collision")
	var block_mesh = new_block_instance.get_node("mesh")
	block_collmesh.disabled
	#block_collmesh.name = "collision_from_"+str(collided_object.transform.origin).replace(" ","")
	block_collmesh.name = "collision_from_"+str(new_block_position).replace(" ","")
	#random color
	if coloreable:
		var material = StandardMaterial3D.new()
		material.albedo_color = random_color()
		block_mesh.material_override = material
	
	grid_container.add_child(new_block_instance)
	
	
	var new_collision_for_body = CollisionShape3D.new()
	new_collision_for_body.set_shape (get_node(block_collmesh.get_path()).get_shape())
	new_collision_for_body.name = block_collmesh.name
	new_collision_for_body.shape.margin=0
	new_collision_for_body.transform.origin = new_block_instance.transform.origin
	grid_container.add_child(new_collision_for_body)




func remove_block(hit_normal,hit_point,collided_object):
	var grid_container = get_parent()
	var grid_size =Vector3(0.5, 0.5, 0.5) #en metros
	#var grid_size =Vector3(1, 1, 1)
	# Compute the grid position based on block size
	var new_block_position = collided_object.transform.origin - (hit_normal.snapped(grid_size)*grid_size)
	# Check if there is already a block at this position (optional, depending on your design)
	for child in grid_container.get_children():
		if child.transform.origin == collided_object.transform.origin:
			child.queue_free()



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
