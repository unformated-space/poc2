extends RayCast3D
class_name Interactor

# TODO: ver si esto tiene sentido paraq inore al body del q nace
@onready var ignore_this := get_node("../../../")
@onready var interact_label = $interact_label
@onready var raycast_end_node = $raycastEnd

@onready var grids_manager := get_node("/root/world/grids_manager")



var focused_object
var collided_object
func _ready():
	add_exception(ignore_this)
	debug_console.log(ignore_this)

func _process(_delta):
	var collided = get_collider()
	#DebugConsole.log(collided)
	interact_label.text = ""
	if focused_object != collided and focused_object != null:
		focused_object._unfocus()
		focused_object = null

	if collided:
		collided_object = collided.get_node("Interactable")

		#debug_console.log(collided.get_class())
		if collided_object and collided_object is Interactable:
			#DebugConsole.log(str(collided_object.name))
			#DebugConsole.log(str(collided_object.get_class()))
			if collided_object.is_interactable == false:
				return
			collided_object._focus(get_collision_point())
			focused_object = collided_object
			
			if collided_object.interact_prompt != "":
				interact_label.text = "[F] " + collided_object.interact_prompt
			elif collided_object.interact_right_click_prompt != "":
				interact_label.text = "[R_click] " + collided_object.interact_right_click_prompt
			elif collided_object.interact_left_click_prompt != "":
				interact_label.text = "[L_click] " + collided_object.interact_left_click_prompt
			else:
				interact_label.text = ""
				
				
			if Input.is_action_just_pressed("interact"):
				collided_object._interact(get_collision_point())
			
			if Input.is_action_just_pressed("mouse_right_click"):
				#collided_object._interact(get_collision_point())
				collided_object._interact_right(get_collision_normal(),get_collision_point(), collided_object)
			
			if Input.is_action_just_pressed("mouse_left_click"):
				#collided_object._interact(get_collision_point())
				collided_object._interact_left(get_collision_normal(),get_collision_point(), collided_object)

		elif collided and collided.get_class()=="VoxelLodTerrain" and Input.is_action_just_pressed("mouse_right_click"):
			
			var _grids = get_node("/root/world/_grids")
			var forward_direction = raycast_end_node.global_transform.basis.z.normalized() * Vector3(0,0 ,1)
			var new_position = get_collision_point ( )  + forward_direction
			grids_manager.create(true, new_position)
	else:
		## TODO: mover esto a gridd
		if Input.is_action_just_pressed("mouse_right_click") :
			var forward_direction = raycast_end_node.global_transform.basis.z.normalized() * Vector3(0,0 ,1)
			var new_position = raycast_end_node.global_position  + forward_direction
			grids_manager.create(false, new_position)


	if Input.is_action_just_released("item_bar_1"):
		Globals.active_item = 0
	if Input.is_action_just_released("item_bar_2"):
		Globals.active_item = 1
	if Input.is_action_just_released("item_bar_3"):
		Globals.active_item = 2
	#if Input.is_action_just_pressed("mouse_right_click") :
		#debug_console.log("entre aca")
		#var forward_direction = raycast_end_node.global_transform.basis.z.normalized() * Vector3(0,0 ,1)
		#var new_position = raycast_end_node.global_position  + forward_direction
		#grids_manager.create(false, new_position)
