extends Block
@export var cammera_scene : Node3D
#@onready var body = get_node("../")
@onready var body = get_parent()

@onready var motion_controller = Movement_controller.new(body, cammera_scene)

@onready var camera_3d = $CameraController/pivot/SpringArm3D/Camera3D
@onready var player = get_node("/root/world/Player")

var player_on =  false
func _init():
	type =  "seat"
#func _ready():
	#type =  "seat"
	#motion_controller.power = 1000
	#body.lock_rotation = true

func _interact(_position, hit_position=Vector3.ZERO):
	debug_console.log(body)
	camera_3d.current =  true
	player_on= true
	player.queue_free()

func _unhandled_input(event):
	if player_on:
		motion_controller.tata(event)

var velocity := Vector3.ZERO
var max_speed = 20
var physics_state

func _process(_delta):
	if player_on:
		if motion_controller.inertiaDampener:
			motion_controller.dampenersContrls()
		motion_controller.jetpack_input =  false
		motion_controller.inertiaDampener = false
	
func _integrate_forces(state):
	physics_state = state

func _physics_process(delta):
	if player_on:
		var direction = motion_controller.handle_movement(Vector3.ZERO, true)
		var speed = handle_speed()
		body.gravity_scale = 0
		
		motion_controller.apply_movement(direction, speed)

func handle_speed():
	return 50
