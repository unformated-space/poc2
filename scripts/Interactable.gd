class_name Interactable
extends Node3D


@export var interact_prompt: String = ""
@export var is_interactable: bool = true

func _interact():
	print ("default interaction")
