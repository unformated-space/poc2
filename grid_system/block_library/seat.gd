extends Block
@export var cammera_scene : Node3D
#@onready var body = get_node("../")
@onready var body = get_parent()
@onready var camera_controller = get_node("CameraController")
@onready var spring_arm_3d = $CameraController/pivot/SpringArm3D

@onready var motion_controller = Movement_controller.new(body, cammera_scene)

@onready var camera_3d = $CameraController/pivot/SpringArm3D/Camera3D
@onready var player = get_node("/root/world/Player")
var player_on =  false
func _init():
	type =  "seat"
	mass_value =  50
	#camera_controller.process_mode = 4
func _ready():
	type =  "seat"
	spring_arm_3d.collision_mask=5
	camera_controller.process_mode = 4
	motion_controller.power = 1000
	body.lock_rotation = true
#
func _unhandled_input(event):
	if player_on:
		motion_controller.tata(event)

var velocity := Vector3.ZERO
var max_speed = 20
var physics_state

func _process(_delta):
	if interactable.interacted_right:
		interactable.interacted_right=false
		grid.add_block( interactable.hit_normal,interactable.hit_point,interactable.collided_object)
	if interactable.interacted_left:
		interactable.interacted_left=false
		grid.remove_block( interactable.hit_normal,interactable.hit_point,interactable.collided_object)

	if interactable.interacted:
		interactable.interacted=false
		camera_3d.current =  true
		player_on= true
		player.queue_free()

	if player_on:
		camera_controller.process_mode = 0
		if motion_controller.inertiaDampener:
			motion_controller.dampenersContrls()
		motion_controller.jetpack_input =  false
		motion_controller.inertiaDampener = false


		
		
func _integrate_forces(state):
	physics_state = state

func _physics_process(delta):
	if player_on:
		var speed = handle_speed()
		camera_controller.process_mode = 0
		var direction = motion_controller.handle_movement(Vector3.ZERO,speed, true)
		body.gravity_scale = 0

func handle_speed():
	return 50
