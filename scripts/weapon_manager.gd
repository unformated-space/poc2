extends Node3D
@onready var tool_library = $WeaponLib
@onready var test = $test
@onready var player = $".."
@onready var voxel_lod_terrain = get_node("/root/world/VoxelLodTerrain")

var current_weapon :=0
var weapon_ammount := 0
var last_weapon = 0
var weapon
var wheel_timer := 0.0
var move_direction := ""
var menu_actual = 0
var weapon_lib
var block_node
# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_ammount=tool_library.get_child_count()
	var block_in_hand = true #basarse en la ui y eso
	#if block_in_hand:
		#var block_instance = load("res://grid_system/Block.tscn").instantiate()
		#var block_mesh = block_instance.get_node(".")
		#var forward_direction = player.global_transform.basis.z.normalized() * 3
		#var new_position = player.global_position  + forward_direction * 1.0
		#block_instance.initial_hit_normal = new_position
		#debug_console.log(block_mesh.get_class())
		#block_mesh.set_script(null)
		#test.add_child(block_instance)
			#
		#block_node = block_mesh
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#debug_console.log(block_node.get_overlapping_areas())
	#if block_node.get_overlapping_bodies():
		#debug_console.log("entre")
		#debug_console.log(block_node.get_overlapping_areas())
	var voxel_tool = voxel_lod_terrain.get_voxel_tool()
	#if voxel_tool.raycast(block_node.global_transform.origin, Vector3.DOWN):
		#pass
#
	#if last_weapon != Globals.active_item:
		#weapon= tool_library.get_child(last_weapon)
		#weapon.visible=false
		#weapon= tool_library.get_child(Globals.active_item)
		#weapon.visible=true
		#last_weapon=Globals.active_item
	#if tool_library.get_child(Globals.active_item).name == "block_tool":
		##var mod_library= tool_library.get_child(Globals.active_item).mod_library
		##var mod_library_instance = mod_library.instantiate()
		##var mod = mod_library_instance.get_child(Globals.active_mod)
		##var preview = tool_library.get_child(Globals.active_item).get_node("block_preview")
		##debug_console.log(mod.get_script())
		#var block_instance = load("res://grid_system/Block.tscn").instantiate()
		#var block_area3d = block_instance.get_node(".")
		#var forward_direction = player.global_transform.basis.z.normalized() * 3
		#var new_position = player.global_position  + forward_direction * 1.0
		#block_instance.initial_hit_normal = new_position
		#block_area3d.set_script(null)
		#if block_area3d.get_overlapping_bodies():
			#debug_console.log(block_area3d.get_overlapping_bodies())
		#if block_area3d.get_overlapping_areas():
			#debug_console.log(block_area3d.get_overlapping_areas ())
		#test.add_child(block_instance)
	#else:
		#if test.get_child(0):
			#test.get_child(0).queue_free()
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

