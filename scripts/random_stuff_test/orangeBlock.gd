extends Interactable

var country_capitals = {
	"Argentina": "Buenos Aires",
	"Australia": "Canberra",
	"Brasil": "Brasilia",
	"China": "Beijing",
	"Ecuador": "Quito",
	"España": "Madrid",
	"Estados Unidos": "Washington D.C.",
	"Francia": "París",
	"Japón": "Tokio",
	"México": "Ciudad de México",
	"Reino Unido": "Londres",
	"Rusia": "Moscú",
	"Suecia": "Estocolmo"
}
func _interact(_position, hit_position=Vector3.ZERO):
	report()
	var selected = show_menu(country_capitals)
	qwe.l (selected)

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_cancel"):
			print("Cancel action triggered.")
			get_tree().get_root().set_input_as_handled()
