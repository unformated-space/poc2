extends Area3D

@onready var cameraController = get_node("/root/world/Player/Player/CameraController")
@onready var cast_end = get_node("/root/world/Player/Player/CameraController/pivot/interact_raycast/raycastEnd")
@onready var cast = get_node("/root/world/Player/Player/CameraController/pivot/interact_raycast")
func _ready():
	#connect("area_entered", _on_Area3D_area_entered)
	monitoring = true
	monitorable = true
var mesh

#func _physics_process(delta):
	#if mesh and has_overlapping_areas():
		#return
		##set_global_rotation_degrees(mesh.get_global_rotation_degrees()*cameraController.rotation.y)
	#else:
		#set_global_rotation_degrees(cast_end.get_global_rotation_degrees())
		#position=cast_end.position

func _on_Area3D_area_entered(area):
	#rotate_z(90)
	#mesh = area.get_node("mesh")
	#debug_console.log(area.get_parent().rotation)
	#set_global_rotation_degrees(area.get_parent().get_global_rotation_degrees())
	#global_transform=area.get_parent().global_transform
	# Assuming you have two BoxMesh instances as children of this node
	var mesh1 = area.get_node("mesh")
	var mesh2 = get_node("mesh")

	# Example collision point and normal (you should get these from a raycast or another method)
	var collision_point = cast.get_collision_point()
	var collision_normal = cast.get_collision_normal()

	# Align the meshes
	var _returns = align_meshes(mesh1, mesh2, collision_point, collision_normal)
	get_parent().basis=_returns[0]
	get_parent().transform=_returns[1]

func align_meshes(mesh1: MeshInstance3D, mesh2: MeshInstance3D, collision_point: Vector3, collision_normal: Vector3):
	# Step 1: Calculate the target position for mesh2
	var mesh1_aabb = mesh1.get_aabb()
	var mesh2_aabb = mesh2.get_aabb()
	
	# Calculate the offset to align the meshes
	var offset = (mesh1_aabb.size + mesh2_aabb.size) * 0.5
	
	# Position the second mesh at the collision point plus the offset along the collision normal
	mesh2.global_transform.origin = collision_point + collision_normal * offset

	# Step 2: Align the rotation of mesh2 to match mesh1
	var mesh1_transform = mesh1.global_transform
	var mesh2_transform = mesh2.global_transform
	
	# Align the rotation
	#mesh2_transform.basis = mesh1_transform.basis
#
	## Apply the transformation to mesh2
	#mesh2.global_transform = mesh2_transform
	return [mesh1_transform.basis, mesh2_transform]
