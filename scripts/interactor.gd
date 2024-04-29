extends RayCast3D
class_name Interactor

# TODO: fix this paths of hell (../../../Player)
@onready var text = get_node("../../../../../../GUI/log")
@onready var ignore_this := get_node("../../../../../Player")
#@onready var interaction_cast = $InteractionCast
@onready var interaction_cast = $"."

#
func interact(interactable: Interactable) -> void:
	if is_instance_valid(interactable):
		interactable.interacted.emit(self)

func focus(interactable: Interactable) -> void:
	interactable.focused.emit(self)

func unfocus(interactable: Interactable) -> void:
	interactable.unfocused.emit(self)

#func interact(player):
	#emit_signal("interacted", player)
	#print("Interacted")
	
#@onready var interactor_cast = $"../SpringArm3D/Camera3D/InteractionCast"
	
# Called when the node enters the scene tree for the first time.
func _ready():
	if interaction_cast:
		interaction_cast.add_exception(ignore_this)
	else:
		print("damn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	##if is_colliding():
	#var interacting_with = interaction_cast.get_collider()
	#
	#text.append_text(str(interacting_with)+"\n")
	##else:
		##text.clear()
		
func _physics_process(_delta: float) -> void:
	if is_colliding():
		var new_closest: Interactable = interaction_cast.get_collider()
		new_closest._on_interaction()
		text.append_text(str(new_closest)+"\n")
