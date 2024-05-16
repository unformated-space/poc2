extends Node

func debugger(args):
	var result = ""
	for arg in args:
		result += " "+str(arg)
	DebugConsole.log(result)
	
