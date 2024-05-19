extends Node
#@onready var chat_log = $chatWindow/VBoxContainer/PanelContainer/MarginContainer/chatLog

func debugger(args):
	var result = ""
	for arg in args:
		result += " "+str(arg)
	DebugConsole.log(result)
	

