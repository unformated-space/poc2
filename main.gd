extends Node3D

#@onready var label = $GUI/Label


func _process(_delta):
	if Input.is_action_pressed("ui_cancel") && !Config.menu_open:
		get_tree().quit()
	##label.set_tex wx wawxxt("FPS "+str(Engine.get_frames_per_second()))
	#
#func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#func _unhandled_input(event):
	#if event is InputEventKey:
		#if event.pressed and event.scancode == KEY_ESCAPE:
			#get_tree().quit()
