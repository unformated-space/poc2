extends Node3D

@onready var label = $GUI/Label


func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	label.set_text("FPS "+str(Engine.get_frames_per_second()))
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
