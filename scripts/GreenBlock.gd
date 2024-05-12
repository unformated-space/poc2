extends Interactable
@onready var mesh_instance_3d = $MeshInstance

var switched := false
var last := ""
# Crea un nuevo material StandardMaterial3D.
 # Color rojo

func random_color():
	# Genera valores aleatorios para los componentes rojo, verde y azul
	var r = randf()  # Genera un número flotante aleatorio entre 0 y 1
	var g = randf()
	var b = randf()

	# Crea y retorna un nuevo color con opacidad completa (1 para el componente alpha)
	return Color(r, g, b, 1)

func _unfocus():
	mesh_instance_3d.set_material_overlay(null)

func _focus(_position):
	var material = ShaderMaterial.new()
	var shader = load("res://assets/shaders/outliner.gdshader")
	material.shader = shader
	mesh_instance_3d.set_material_overlay(material)

func _interact(_position, hit_position=Vector3.ZERO):
	print("saraseado")
	print(mesh_instance_3d.get_active_material(0))
	var material = StandardMaterial3D.new()
	material.albedo_color = random_color()
	mesh_instance_3d.material_override = material
