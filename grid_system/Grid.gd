extends Interactable
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
	#for enemigo in get_tree().get_nodes_in_group(grid_UUID):
		#DebugConsole.log("the friends"+ str(enemigo))
	connect("child_entered_tree", block_added)
	#DebugConsole.log("sala"+str(position))
	#DebugConsole.log("vody"+str(grid_body.position))
func _process(delta):
	#position=grid_body.position

	pass


func block_added(id):
	if id.name.begins_with("area"):
		grid.append(id)
		id.add_to_group(grid_UUID)
		#DebugConsole.log(grid)
	#for enemigo in get_tree().get_nodes_in_group(grid_UUID):
		#DebugConsole.log("the friends "+ str(enemigo))
