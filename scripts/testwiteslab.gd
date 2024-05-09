extends Interactable

@onready var collision_shape_3d = $CollisionShape3D

func _interact(_position):
	report()
	
