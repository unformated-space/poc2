extends Control

var current_tool := 0
var tool_lib : Node
var mod_lib : PackedScene
var mod_options : Node
var wheel_timer := 0.0
var move_direction := ""


@onready var tool_list : Node = $tool_list
@onready var tool_mod_1 : Node = $tool_mod1
@onready var tool_list_back : Node = $tool_list_back
@onready var mod_list_1_back : Node = $mod_list_1_back
#
#func _ready():
	## Instantiate tool_lib only once
	#tool_lib = load("res://scenes/tool_lib.tscn").instantiate()
	#for tool in tool_lib.get_children():
		#var thumb : TextureRect = tool.get_node("thumb")
		#thumb.visible = true
		#thumb.name = tool.tool_name
		#thumb.reparent(tool_list)
#
#func _process(delta):
	## Simplified wheel selection logic
	#if Globals.wheel_selected == 0:
		#update_tool_wheel()
	#elif Globals.wheel_selected == 1:
		#update_mod_wheel()
#
	## Timer optimization
	#if wheel_timer > 0.0:
		#wheel_timer += delta
	#if wheel_timer > 0.5:
		#wheel_timer = 0.0
#
	## Simplified move direction logic
	#if move_direction != "":
		#if wheel_timer > 0.0 && wheel_timer < 0.5:
			#if move_direction == "fwd":
				#current_tool -= 1
				#move_direction = ""
			#elif move_direction == "dwn":
				#current_tool += 1
				#move_direction = ""
		#current_tool = wrapi(current_tool, 0, tool_lib.get_child_count())
#
#func update_tool_wheel():
	#tool_list_back.visible = true
	#mod_list_1_back.visible = false
	#var ammount := tool_lib.get_child_count()
	#update_ui_wheels(current_tool)
	#mod_lib = tool_lib.get_child(current_tool).mod_library
	#if mod_lib:
		#mod_options = mod_lib.instantiate()
		#for mod in mod_options.get_children():
			#var thumb : TextureRect = mod.get_node("thumb")
			#thumb.visible = true
			#thumb.reparent(tool_mod_1)
		#Globals.active_item = current_tool
#
#func update_mod_wheel():
	#tool_list_back.visible = false
	#mod_list_1_back.visible = true
	#var ammount := mod_options.get_child_count()
	#update_ui_wheels(current_tool)
	#Globals.active_mod = current_tool
#
#func update_ui_wheels(current_tool):
	#var wheel : Node
	#if Globals.wheel_selected == 0:
		#wheel = tool_list
	#elif Globals.wheel_selected == 1:
		#wheel = tool_mod_1
#
	#var previous_index := wrapi(current_tool - 1, 0, wheel.get_child_count())
	#var current_index := wrapi(current_tool, 0, wheel.get_child_count())
	#var next_index := wrapi(current_tool + 1, 0, wheel.get_child_count())
#
	#wheel.move_child(wheel.get_child(previous_index), 0)
	#wheel.move_child(wheel.get_child(current_index), 1)
	#wheel.move_child(wheel.get_child(next_index), 2)
#
#func _unhandled_input(event):
	#if event.is_action_released("item_bar_1", true):
		#Globals.wheel_selected = 0
	#if event.is_action_released("item_bar_2", true):
		#Globals.wheel_selected = 1
	#if event.is_action_released("mouse_up", true):
		#move_direction = "dwn"
		#wheel_timer += 0.1
	#if event.is_action_released("mouse_down", true):
		#move_direction = "fwd"
		#wheel_timer += 0.1
##func mouse_wheel_ui_input(current, ammount, move_direction):
#
