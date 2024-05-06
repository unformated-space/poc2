extends RayCast3D
class_name Interactor

# TODO: fix this paths of hell (../../../Player)
@onready var ignore_this := get_node("../../../../../Player")
@onready var interact_label = $interact_label


func _ready():
	add_exception(ignore_this)
	pass # Replace with function body.


func _process(_delta):
	var object = get_collider()
	interact_label.text = ""
	if object:
		if object and object is Interactable:
			if object.is_interactable == false:
				return
			if object.interact_prompt != "":
				interact_label.text = "[F] " + object.interact_prompt
			else:
				interact_label.text = ""
			if Input.is_action_just_pressed("interact"):
				object._interact(get_collision_point())
			
			if Input.is_action_just_pressed("mouse_right_click"):
				#object._interact(get_collision_point())
				object._interact_right(get_collision_normal(), object)
			if Input.is_action_just_pressed("mouse_left_click"):
				#object._interact(get_collision_point())
				object._interact_left(get_collision_normal(), object)
	else:
		if Input.is_action_just_pressed("mouse_right_click"):
			var static_grids = get_node("/root/world/static_grids")
			var block_instance = load("res://grid-system/grid_container.tscn").instantiate()
			var forward_dir = global_transform.basis.z.normalized()

			# Calcular la nueva posición delante de la cámara
			var block_position = global_transform.origin + (forward_dir * Vector3(0,0,-10))

			block_instance.global_transform.origin = block_position
			static_grids.add_child(block_instance)
