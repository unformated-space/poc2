extends RayCast3D
class_name Interactor

# TODO: fix this paths of hell (../../../Player)
@onready var ignore_this := get_node("../../../../../Player")
@onready var interact_label = $interact_label

var collided_object

func _ready():
	add_exception(ignore_this)
	pass # Replace with function body.


func _process(_delta):
	var object = get_collider()
	#DebugConsole.log(object)
	interact_label.text = ""
	if collided_object != object and collided_object != null:
		collided_object._unfocus()
		collided_object = null

	if object:
		if object and object is Interactable:
			if object.is_interactable == false:
				return
			object._focus(get_collision_point())
			collided_object = object
			if object.interact_prompt != "":
				interact_label.text = "[F] " + object.interact_prompt
			else:
				interact_label.text = ""
			if Input.is_action_just_pressed("interact"):
				object._interact(get_collision_point())
			if object.interact_prompt != "":
				interact_label.text = "[R_click] " + object.interact_right_click_prompt
			else:
				interact_label.text = ""
			if Input.is_action_just_pressed("mouse_right_click"):
				#object._interact(get_collision_point())
				object._interact_right(get_collision_normal(), object)
			if object.interact_prompt != "":
				interact_label.text = "[L_click] " + object.interact_left_click_prompt
			else:
				interact_label.text = ""
			if Input.is_action_just_pressed("mouse_left_click"):
				#object._interact(get_collision_point())
				object._interact_left(get_collision_normal(), object)
	else:
		if Input.is_action_just_pressed("mouse_right_click"):
			var _grids = get_node("/root/world/_grids")
			var block_instance = load("res://grid_system2/Block.tscn").instantiate()
			var forward_dir = global_transform.basis.z.normalized()

			# Calcular la nueva posición delante de la cámara
			var block_position = global_transform.origin + (forward_dir * Vector3(0,0,-10))

			block_instance.global_transform.origin = block_position
			_grids.add_child(block_instance)
