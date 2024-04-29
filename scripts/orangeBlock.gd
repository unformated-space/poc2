extends Interactable
@onready var mesh_instance_3d = $MeshInstance3D

func _interact():
	print("me tocaron el culo")
	print(mesh_instance_3d.get_active_material(0))
