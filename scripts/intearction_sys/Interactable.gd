class_name Interactable
extends Node3D

var menu_index :=0
var menu_lenght := 0
var wheel_timer := 0.0
var move_direction := ""
var menu_actual = 0
var menu : PopupMenu

@export var mesh_instance_3d: MeshInstance3D

@export var interact_prompt: String = ""
@export var interact_left_click_prompt: String = ""
@export var interact_right_click_prompt: String = ""
@export var is_interactable: bool = true
@export var is_focuseable: bool = true



func _interact(hit_normal, hit_position = Vector3.ZERO):
	DebugConsole.log(hit_normal)


func _unfocus():
	if is_focuseable:
		mesh_instance_3d.set_material_overlay(null)

func _focus(_position):
	if is_focuseable:
		var material = ShaderMaterial.new()
		var shader = load("res://assets/shaders/outliner.gdshader")
		material.shader = shader
		mesh_instance_3d.set_material_overlay(material)
	
func _interact_left(hit_normal, hit_position, collided_object):
	DebugConsole.log(collided_object)
func _interact_right(hit_normal, hit_position, collided_object):
	DebugConsole.log(collided_object)

	
	
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
 

