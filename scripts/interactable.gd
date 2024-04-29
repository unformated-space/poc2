extends RigidBody3D

class_name Interactable

@export var interactble = true
@export var interactableMesh := CollisionShape3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Emitted when an Interactor starts looking at me.
signal focused(interactor: Interactor)
# Emitted when an Interactor stops looking at me.
signal unfocused(interactor: Interactor)
# Emitted when an Interactor interacts with me.
signal interacted(interactor: Interactor)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interaction ():
	print ("INTERACTED")
