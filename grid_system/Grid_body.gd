extends PhysicsBody3D

var grid_UUID:String
var grid : Dictionary
var block_path =  ["res://grid_system/Block.tscn", "res://grid_system/block_library/seat.tscn"]
@onready var grid_body = $"."


func _ready():
	if name.begins_with("UUID"):
		grid_UUID= name
	else:
		grid_UUID="UUID"+str(ResourceUID.create_id())
		name= grid_UUID
	connect("child_entered_tree", block_added)
	add_block(Vector3.ZERO, Vector3.ZERO, Object)

func add_block(hit_normal,hit_point,collided_object):
	var grid_size =Vector3(0.5, 0.5, 0.5) #en metros
	#var new_block_position= collided_object.get_node("../").transform.origin.snapped(grid_size) +  (collided_object.get_node("../").to_local(hit_point.snapped(grid_size))+hit_normal.snapped(grid_size)*grid_size)
	var new_block_position
	if hit_normal== Vector3.ZERO:
		new_block_position = hit_normal
	else:
		new_block_position= collided_object.get_node("../").transform.origin.snapped(grid_size) +  hit_normal.snapped(grid_size)*grid_size
	
	# Check if there is already a block at this position (optional, depending on your design)
	for child in get_children():
		if child.transform.origin == new_block_position:
			DebugConsole.log("Warning: Block already here "+child.name)
			return
			
	# Instance the block
	var new_block_instance = load(block_path[Globals.active_item]).instantiate()
	new_block_instance.name = "area_from_"+str(new_block_position).replace(" ","")
	# Add the block instance to the current node or another parent node
	new_block_instance.transform.origin = new_block_position

	var block_collmesh = new_block_instance.get_node("collision")
	var block_mesh = new_block_instance.get_node("mesh")
	block_collmesh.disabled
	block_collmesh.name = "collision_from_"+str(new_block_position).replace(" ","")
	#random color
	#debug_console.log(str(coloreable)+" "+name+" "+type)
	#if coloreable:2
		#var material = StandardMaterial3D.new()
		#material.albedo_color = qwetool.random_color()
		#block_mesh.material_override = material
	
	add_child(new_block_instance)
	
	var new_collision_for_body = CollisionShape3D.new()
	new_collision_for_body.set_shape (get_node(block_collmesh.get_path()).get_shape())
	new_collision_for_body.name = block_collmesh.name
	new_collision_for_body.shape.margin=0
	new_collision_for_body.transform.origin = new_block_instance.transform.origin
	add_child(new_collision_for_body)

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





func block_added(id):
	if id.name.begins_with("area"):
		grid[id.name]={"type": id.type,"mass_value": id.mass_value}
		id.add_to_group(grid_UUID)
		if grid_body.get_class() == "RigidBody3D":
			grid_body.mass = grid[id.name]["mass_value"]
	##for enemigo in get_tree().get_nodes_in_group(grid_UUID):
		##DebugConsole.log("the friends "+ str(enemigo))
		#debug_console.log(grid[id.name])
