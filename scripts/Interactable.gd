class_name Interactable
extends Node3D

var menu_index :=0
var menu_lenght := 0
var wheel_timer := 0.0
var move_direction := ""
var menu_actual = 0
var menu : PopupMenu
@export var interact_prompt: String = ""
@export var is_interactable: bool = true

func _interact(_position):
	DebugConsole.log(_position)

func _unfocus():
	pass

func _focus(_position):
	pass
	
func _interact_left(_position, object):
	DebugConsole.log(_position)
func _interact_right(_position, object):
	DebugConsole.log(_position)

	
	
func report():
	DebugConsole.log("resistance is futile")

func show_menu(item_map):
	Config.menu_open=true
	var node_scene = load("res://scenes/control.tscn").instantiate()
	add_child(node_scene)
	menu = node_scene.get_node("menu")
	var i = 0
	for key in item_map:
		menu.add_item(item_map[key],i)
		i +=1
	menu_lenght = item_map.keys().size()
	DebugConsole.log(menu_index)
	menu.connect("popup_hide", menu_hide)

	var size = menu.get_size ()
	menu.popup(Rect2(
					get_viewport().size.x/2-(size.x/2), 
					get_viewport().size.y/2-(size.y/2),
					size.x, 
					size.x))
	menu.connect("index_pressed", _onPress)
	
func _onPress(id_pressed):
	Config.menu_open=false
	DebugConsole.log(id_pressed)
	
func menu_hide():
	DebugConsole.log ("me cerre")
	Config.menu_open=false

func _process(delta):
	if menu:
		menu.set_focused_item(menu_index)
	if (wheel_timer > 0.0):
		wheel_timer += get_process_delta_time()
	if (wheel_timer > 0.5):
		wheel_timer = 0.0
	if move_direction != "":
		if wheel_timer > 0.0 && wheel_timer < 0.4:
			if move_direction == "fwd":
				menu_index +=1
				move_direction = ""
				DebugConsole.log("cama arriba")
			else:
				DebugConsole.log("cama abajo")
				menu_index -=1
				move_direction = ""
	menu_index = wrapi(menu_index, 0, menu_lenght)
	
	if Input.is_action_just_pressed("mouse_down"):
		wheel_timer +=0.1
		move_direction = "fwd"
	if Input.is_action_just_pressed("mouse_up"):
		wheel_timer +=0.1
		move_direction = "dwn"




