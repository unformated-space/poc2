class_name Grid
extends Node3D
@onready var grid_body = $grid_body
@onready var grid_body_collision = $grid_body/grid_body_collision
@onready var grid_container = $"."

const BASE_STATIC = "res://grid_system2/Block.tscn"

var grid_UUID:String
var grid : Array
func _ready():
	if name.begins_with("UUID"):
		grid_UUID= name
	else:
		grid_UUID="UUID"+str(ResourceUID.create_id())
		name= grid_UUID
	for enemigo in get_tree().get_nodes_in_group(grid_UUID):
		DebugConsole.log("the friends"+ str(enemigo))
	$grid_body.connect("child_entered_tree", block_added)
func _process(delta):
	pass


func block_added(id):
	grid.append(id)
	add_to_group(grid_UUID)
	for enemigo in get_tree().get_nodes_in_group(grid_UUID):
		DebugConsole.log("the friends "+ str(enemigo))

#
#func _interact_right(_position, objecwt):
	#add_block(BASE_STATIC, _position,object)

#func _interact_left(_position, object):
	#remove_block(BASE_STATIC, _position,object)
	#
#func debugger(args):
	#var result = ""
	#for arg in args:
		#result += " "+str(arg)
	#DebugConsole.log(result)
#
#func add_block(scene,hit_normal,object):
	#var grid_size =Vector3(0.5, 0.5, 0.5)
	##var grid_size =Vector3(1, 1, 1)w
	## Compute the grid position based on block size
	#var grid_position = (object.transform.origin )+( hit_normal* grid_size ) 
	##debugger([object.transform.origin.floor() , hit_normal.floor()])
	## Check if there is already a block at this position (optional, depending on your design)
	#for child in grid_container.get_children():
		#if child.global_transform.origin == grid_position:
			#return # Block already exists at this positiondw
#
	## Instance the block
	#var block_instance = load(scene).instantiate()
	#block_instance.transform.origin = grid_position
	## Add the block instance to the current node or another parent node
#
	#grid_container.add_child(block_instance)
	#block_instance.grid_UUID = grid_UUID
#
#func remove_block(scene,hit_normal,object):
	#var grid_size =Vector3(-0.5, -0.5, -0.5)
	##var grid_size =Vector3(1, 1, 1)w
	## Compute the grid position based on block size
	#var grid_position = hit_normal *grid_size
	#debugger([object.get_path()])
	#grid_container.remove_child(object)
