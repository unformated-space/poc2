extends Node
#@onready var chat_log = $chatWindow/VBoxContainer/PanelContainer/MarginContainer/chatLog

func debugger(args):
	var result = ""
	for arg in args:
		result += " "+str(arg)
	DebugConsole.log(result)
	

func random_color():
	# Genera valores aleatorios para los componentes rojo, verde y azul
	var r = randf()  # Genera un número flotante aleatorio entre 0 y 1
	var g = randf()
	var b = randf()
	return Color(r, g, b, 1)
