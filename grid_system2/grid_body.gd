extends Block

var grid

func _ready():
	grid=get_parent()
	DebugConsole.log (grid.name)

func _physics_process(delta):
	grid.global_transform = global_transform
