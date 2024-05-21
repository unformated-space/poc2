class_name Block
extends Area3D
@export var coloreable : bool = true
@export var thumbnail : Resource
@onready var interactable = $Interactable
@onready var grid = get_parent()
#@onready var grid_container = $"."
var type =  "armor"
#@onready var test_block = get_node("/root/world/Entity/Player/right_hand/test/Block")
var block_path =  ["res://grid_system/Block.tscn", "res://grid_system/block_library/seat.tscn"]
#func _interact_right(hit_normal, hit_point, collided_object):
	#add_block( hit_normal,hit_point,collided_object)
#
#func _interact_left(hit_normal, hit_point, collided_object):
	#remove_block( hit_normal,hit_point,collided_object)
#
func _process(_delta):
	if interactable.interacted_right:
		interactable.interacted_right=false
		grid.add_block( interactable.hit_normal,interactable.hit_point,interactable.collided_object)
	if interactable.interacted_left:
		interactable.interacted_left=false
		grid.remove_block( interactable.hit_normal,interactable.hit_point,interactable.collided_object)

