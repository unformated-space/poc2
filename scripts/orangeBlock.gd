extends Interactable

var sarlanga = ["una", "dos"]
func _interact(_position):
	report()
	var menu = show_menu(sarlanga)
	menu.connect("id_pressed", _onPress)



func _onPress(id_pressed):
	Config.menu_open=false
	DebugConsole.log(id_pressed)

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_cancel"):
			print("Cancel action triggered.")
			get_tree().get_root().set_input_as_handled()
