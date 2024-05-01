extends RayCast3D
class_name Interactor

# TODO: fix this paths of hell (../../../Player)
@onready var text = get_node("../../../../../../GUI/log")
@onready var ignore_this := get_node("../../../../../Player")
@onready var interact_label = $interact_label


func _ready():
	add_exception(ignore_this)
	pass # Replace with function body.


func _process(_delta):
	var object = get_collider()
	interact_label.text = ""
	if object and object is Interactable:
		if object.is_interactable == false:
			return
		interact_label.text = "[F] " + object.interact_prompt
		if Input.is_action_just_pressed("interact"):
			object._interact()
	

