class_name Interactable
extends Node3D


@export var interact_prompt: String = ""
@export var is_interactable: bool = true

func _interact(_position):
	DebugConsole.log(_position)

func show_menu(item_list):
	Config.menu_open=true
	var node_scene = load("res://scenes/control.tscn").instantiate()
	add_child(node_scene)
	var menu = node_scene.get_node("menu")
	DebugConsole.log(get_viewport().size)
	for i in item_list:
		var inde = 0
		menu.add_item(i, inde)
		inde =inde+1
	menu.connect("popup_hide", menu_hide)
	menu.popup(Rect2(get_viewport().size.x/2-25, get_viewport().size.y/2-25,50, 50))
	return menu
	
func menu_hide():
	DebugConsole.log ("me cerre")
	Config.menu_open=false

func report():
	DebugConsole.log("resistance is futile")

#func on
#character_instance.connect("died", self, "_on_Character_died")
