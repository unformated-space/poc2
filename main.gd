extends Node3D



func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
