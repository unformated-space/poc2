extends Node

func input_action(event, action, just : bool = false, as_readed: bool = false):
	if event.is_action_pressed(action) and !just:
		return true
	if event.is_action_released(action,just):
		return false
