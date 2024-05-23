extends Node3D
@onready var interactable = $Interactable

@export var mesh_instance_3d : MeshInstance3D
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

func _process(delta):
	if interactable.interacted:
		qwe.l("saraseado")
		var material = StandardMaterial3D.new()
		material.albedo_color = random_color()
		mesh_instance_3d.material_override = material
	
