extends RayCast3D
class_name Interactor

# TODO: fix this paths of hell (../../../Player)
@onready var ignore_this := get_node("../../../../../Player")
@onready var interact_label = $interact_label

var focused_object

func _ready():
	add_exception(ignore_this)
	pass # Replace with function body.


func _process(_delta):
	var collided_object = get_collider()
	#DebugConsole.log(collided_object)
	interact_label.text = ""
	if focused_object != collided_object and focused_object != null:
		focused_object._unfocus()
		focused_object = null

	if collided_object:
		if collided_object and collided_object is Interactable:
			#DebugConsole.log(str(collided_object.name))
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
				print ("collided_object "+str(collided_object.name))
			
			if Input.is_action_just_pressed("mouse_left_click"):
				#collided_object._interact(get_collision_point())
				print ("collided_object "+str(collided_object.name))
				collided_object._interact_left(get_collision_normal(),get_collision_point(), collided_object)
	else:
		## TODO: mover esto a gridd
		if Input.is_action_just_pressed("mouse_right_click"):
			var block_in_hand = true #basarse en la ui y eso
			if block_in_hand:
				var _grids = get_node("/root/world/_grids")
				var block_instance = load("res://grid_system2/Block.tscn").instantiate()
				var forward_direction = ignore_this.global_transform.basis.z.normalized() * -1
				var new_position = ignore_this.global_position  + forward_direction * 1.0
				# Calcular la nueva posición delante de la cámara
				#DebugConsole.log("player pos"+str(global_position))
				#DebugConsole.log("onCreate"+str(new_position))
				block_instance.initial_hit_normal = new_position
				_grids.add_child(block_instance)
