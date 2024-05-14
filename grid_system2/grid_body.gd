extends Interactable
#
var grid
#
#func _ready():
	#grid=get_parent()
	#DebugConsole.log (grid.name)
#
func _physics_process(delta):
	var grid_container=get_parent()
	grid_container.global_transform = global_transform
