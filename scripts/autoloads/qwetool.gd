extends Node
#@onready var chat_log = $chatWindow/VBoxContainer/PanelContainer/MarginContainer/chatLog

func d(args):
	var chat_log = get_node("/root/world/GUI/chatWindow/VBoxContainer/PanelContainer/MarginContainer/chatLog")
	var result = ""
	for arg in args:
		result += " "+str(arg)
	chat_log.add_text(result+"\n")

func l(args):
	var chat_log = get_node("/root/world/GUI/chatWindow/VBoxContainer/PanelContainer/MarginContainer/chatLog")
	chat_log.add_text(str(args)+"\n")

func random_color():
	# Genera valores aleatorios para los componentes rojo, verde y azul
	var r = randf()  # Genera un número flotante aleatorio entre 0 y 1
	var g = randf()
	var b = randf()
	return Color(r, g, b, 1)
