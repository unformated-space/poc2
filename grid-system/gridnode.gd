class_name Static_Grid
extends Node3D
var grid_UUID:String
var grid : Array
func _ready():
	grid_UUID="UUID"+str(ResourceUID.create_id())
	for enemigo in get_tree().get_nodes_in_group(grid_UUID):
		DebugConsole.log("the friends"+ str(enemigo))
	connect("child_entered_tree", block_added)
func _process(delta):
	pass



func block_added(id):
	for enemigo in get_tree().get_nodes_in_group(grid_UUID):
		DebugConsole.log("the friends"+ str(enemigo))
