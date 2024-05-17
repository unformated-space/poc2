extends Control



#var current_wheel :=02
#var current_tool :=0
#var weapon_ammount := 0
#var last_weapon = 0
#var weapon
var move_direction = ""
var wheel_timer := 0.0
var current =0
var ammount =0
var old_tool
var menu_actual = 0
var tool_lib = preload("res://scenes/tool_lib.tscn").instantiate()
@onready var tool_list = $tool_list
@onready var tool_mod_1 = $tool_mod1
@onready var tool_list_back = $tool_list_back
@onready var mod_list_1_back = $mod_list_1_back
var mod_lib
var mod_options
# Called when the node enters the scene tree for the first time.
func _ready():

	for tool in tool_lib.get_children():
		#print ( tool.get_node("thumb"))
		var thumb : TextureRect = tool.get_node("thumb")
		thumb.visible= true
		thumb.name=tool.tool_name
		thumb.reparent(tool_list)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):


	if Globals.wheel_selected == 0:
		tool_list_back.visible=true
		mod_list_1_back.visible=false
		ammount = tool_lib.get_child_count()
		update_ui_wheels( Globals.active_item)

		mod_lib = tool_lib.get_child(current).mod_library
		if mod_lib and current != Globals.active_item:
			if tool_mod_1.get_child_count() > 0:
				for child in tool_mod_1.get_children():
					child.queue_free()
			mod_options = mod_lib.instantiate()
			for mod in mod_options.get_children():
				var thumb : TextureRect = mod.get_node("thumb")
				thumb.visible= true
				thumb.reparent(tool_mod_1)
		Globals.active_item = current
	elif Globals.wheel_selected == 1:
		tool_list_back.visible=false
		mod_list_1_back.visible=true
		if mod_lib:
			ammount = mod_options.get_child_count()
			update_ui_wheels( Globals.active_mod)
			Globals.active_mod = current
	if (wheel_timer > 0.0):
		wheel_timer += get_process_delta_time()
	if (wheel_timer > 0.5):
		wheel_timer = 0.0
	if move_direction != "":
		if wheel_timer > 0.0 && wheel_timer < 0.5:
			if move_direction == "fwd":
				current -=1
				move_direction = ""
			elif move_direction == "dwn":
				current +=1
				move_direction = ""
			update_ui_wheels (current)
	current = wrapi( current, 0, ammount)



		
		

func _unhandled_input(event):
	if event.is_action_released("item_bar_1", true):
		Globals.wheel_selected = 0
	if event.is_action_released("item_bar_2", true):
		Globals.wheel_selected = 1
	if event.is_action_released("mouse_up", true):
		move_direction = "dwn"
		wheel_timer +=0.1
	if event.is_action_released("mouse_down", true):
		move_direction = "fwd"
		wheel_timer +=0.1
		
func update_ui_wheels (current_tool):
	var wheel
	if Globals.wheel_selected == 0:
		wheel = tool_list
	elif  Globals.wheel_selected == 1:
		wheel = tool_mod_1
	wheel.move_child(wheel.get_child((wrapi( current_tool, 0, ammount) - 1)), 0)
	wheel.move_child(wheel.get_child(current_tool), 1)
	wheel.move_child(wheel.get_child((wrapi( current_tool, 0, ammount) + 1)), 2)

#
#func mouse_wheel_ui_input(current, ammount, move_direction):

