extends Node
@onready var tool_library = $WeaponLib


var current_weapon :=0
var weapon_ammount := 0
var last_weapon = 0
var weapon
var wheel_timer := 0.0
var move_direction := ""
var menu_actual = 0
var menu : PopupMenu
var weapon_lib
# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_ammount=tool_library.get_child_count()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if last_weapon != Globals.active_item:
		weapon= tool_library.get_child(last_weapon)
		weapon.visible=false
		weapon= tool_library.get_child(Globals.active_item)
		weapon.visible=true
		last_weapon=Globals.active_item
	if tool_library.get_child(Globals.active_item).name == "block_tool":
		var mod_library= tool_library.get_child(Globals.active_item).mod_library
		var mod_library_instance = mod_library.instantiate()
		var mod = mod_library_instance.get_child(Globals.active_mod)
		var preview = tool_library.get_child(Globals.active_item).get_node("block_preview")
		debug_console.log(mod.get_script())
		#mod.get_child(0).set_script(false)
		#preview.add_child(mod)
		

	#if (wheel_timer > 0.0):
		#wheel_timer += get_process_delta_time()
	#if (wheel_timer > 0.5):
		#wheel_timer = 0.0
	#if move_direction != "":
		#if wheel_timer > 0.0 && wheel_timer < 0.8:
			#if move_direction == "fwd":
				#current_weapon +=1
				#
				#move_direction = ""
				#DebugConsole.log("cama arriba")
			#else:
				#DebugConsole.log("cama abajo")
				#current_weapon -=1
				#move_direction = ""
	#current_weapon = wrapi(current_weapon, 0, weapon_ammount)
	#
	#if Input.is_action_just_pressed("mouse_down"):
		#wheel_timer +=0.1
		#move_direction = "fwd"
	#if Input.is_action_just_pressed("mouse_up"):
		#wheel_timer +=0.1
		#move_direction = "dwn"
