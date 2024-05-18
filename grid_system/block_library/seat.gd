extends Block

@onready var body = get_parent()

func _interact(_position, hit_position=Vector3.ZERO):
	debug_console.log(body)
	var material = StandardMaterial3D.new()
	material.albedo_color = random_color()
	mesh_instance_3d.material_override = material
	body.rotate_x(+1)
	
