class_name Block
extends Area3D
@export var coloreable : bool = true
@export var thumbnail : Resource
@onready var interactable = $Interactable

#@onready var grid_container = $"."
var type =  "armor"
#@onready var test_block = get_node("/root/world/Entity/Player/right_hand/test/Block")
var block_path =  ["res://grid_system/Block.tscn", "res://grid_system/block_library/seat.tscn"]
#func _interact_right(hit_normal, hit_point, collided_object):
	#add_block( hit_normal,hit_point,collided_object)
#
#func _interact_left(hit_normal, hit_point, collided_object):
	#remove_block( hit_normal,hit_point,collided_object)

func _process(_delta):
	if interactable.interacted_right:
		#qwetool.debugger(["normal",interactable.hit_normal,"coll",interactable.collided_object])
		interactable.interacted_right=false
		add_block( interactable.hit_normal,interactable.hit_point,interactable.collided_object)
	if interactable.interacted_left:
		interactable.interacted_left=false
		remove_block( interactable.hit_normal,interactable.hit_point,interactable.collided_object)

func add_block(hit_normal,hit_point,collided_object):
	var grid_container = get_parent()
	#debug_console.log(grid_container)
	var grid_size =Vector3(0.5, 0.5, 0.5) #en metros
	#var grid_size =Vector3(1, 1, 1)
	# Compute the grid position based on block size
	var new_block_position = collided_object.transform.origin + (hit_normal.snapped(grid_size)*grid_size)
	# Check if there is already a block at this position (optional, depending on your design)
	qwetool.debugger(["new",new_block_position,"normal",hit_normal.snapped(grid_size),"x grid",(hit_normal*grid_size),"coll",collided_object.transform.origin])
	for child in grid_container.get_children():
		if child.transform.origin == new_block_position:
			DebugConsole.log("Warning: Block already here "+child.name)
			return # Block already exists at this positiondw

	# Instance the block
	var new_block_instance = load(block_path[Globals.active_item]).instantiate()
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
		material.albedo_color = qwetool.random_color()
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




# Called when the node enters the scene tree for the first time.
#func _ready():
	#var grids_root = get_parent()
	#if grids_root.name == "grids_manager" and first_block:
		#var new_grid_container
		#var voxel_tool = voxel_lod_terrain.get_voxel_tool()
		#if initial_object:
			#if initial_object.get_class() == "VoxelLodTerrain":
				#new_grid_container = load("res://grid_system/Static_grid.tscn").instantiate()
		#else:
			#new_grid_container = load("res://grid_system/Dynamic_grid.tscn").instantiate()
		#var UUID = "UUID"+str(ResourceUID.create_id())
		#new_grid_container.name=UUID
		#new_grid_container.position = initial_hit_normal
		#grids_root.add_child(new_grid_container)
		#position=initial_hit_normal
		#var grid_body = get_node("/root/world/grids_manager/"+UUID+"/grid_body")
	#
		###collision adding 
		#var grid_mesh = MeshInstance3D.new()
		#grid_mesh.mesh = mesh.mesh
		#grid_mesh.name= "grid_body_mesh"
		#grid_mesh.set_layer_mask_value(1, false)
		#grid_mesh.set_layer_mask_value(2, true)
		##random color
		#if coloreable:
			#var material = StandardMaterial3D.new()
			#material.albedo_color = random_color()
			#mesh.material_override = material
		#
		#new_grid_container.add_child(grid_mesh)
		#
		#var new_collision_for_body = CollisionShape3D.new()
		#new_collision_for_body.set_shape (collision.get_shape())
		#new_collision_for_body.name = "collision_from_(0,0,0)"
		#new_collision_for_body.shape.margin=0
		#new_grid_container.add_child(new_collision_for_body)
#
#
#
		##mesh_instance_3d=mesh
		#name="area_from_(0,0,0)"
		#mesh.set_layer_mask_value(1, false)
		#mesh.set_layer_mask_value(2, true)
		#reparent(new_grid_container, true)

