class_name Movement_controller
extends RigidBody3D

#@onready var camera_contrsoller = get_node("./CameraController")

@export var camera_controller: Node3D
@onready var camera = get_node(camera_controller.get_path())

var align_to_gravity = false
var gravity := 9.8
var dampeners := true
var power := 100


#internal vars for movement
var move_fwd : bool =  false
var move_back : bool =  false
var move_right: bool =  false
var move_left : bool =  false
var jump: bool =  false
var crouch : bool =  false
var rotate_left: bool =  false
var rotate_right : bool =  false

#for player
var jetpack_input : bool =  false
var inertiaDampener : bool =  false
var sprint_boost : bool =  false

func apply_rotation(quat):
	var new_basis = Basis(quat) * global_transform.basis
	global_transform.basis = new_basis

## FIXME: check if player_jetpacking is the best way or pass an available movemet angles based on trhusters available
func handle_movement(direction, player_jetpacking: bool = false):
	var rotation_speed = 0.01
	var quatz := Quaternion.IDENTITY
	#if direction == Vector3.ZERO:
	if move_fwd:
		direction += -transform.basis.z
	if move_back:
		direction += transform.basis.z
	if move_left:
		direction += -transform.basis.x
	if move_right:
		direction += transform.basis.x
	if player_jetpacking:
		if jump:
			direction += transform.basis.y
		if crouch:
			direction += -transform.basis.y
			
		quatz *= Quaternion(transform.basis.x,camera.camera_angle_z)
		if rotate_left:
			quatz *= Quaternion(transform.basis.z, rotation_speed)  # Rotate around local z-axis
		elif rotate_right:
			quatz *= Quaternion(transform.basis.z, -rotation_speed)
		apply_rotation(quatz)
	apply_rotation(Quaternion(transform.basis.y, camera.camera_angle_y)*quatz)
	camera.camera_angle_y = 0.0
	camera.camera_angle_z = 0.0
	return direction



func apply_movement(direction, speed):
	if direction.length() > 0:
		direction = direction.normalized() * speed
	apply_central_force(direction * power)

	var current_velocity = linear_velocity
	var current_speed = current_velocity.length()
	if current_speed > speed:
		current_velocity = current_velocity.normalized() * speed
		linear_velocity = current_velocity
#
func dampenersContrls():
	dampeners = !dampeners
	if dampeners:
		linear_damp = 4
	else:
		linear_damp = 0

func align_to_gravity_direction(delta):
	rotation.z = lerp( rotation.z ,0.0, delta * Config.lerpSpeed)
	rotation.x = lerp( rotation.x ,0.0, delta * Config.lerpSpeed)


func _unhandled_input(event):
	move_fwd = event.is_action_pressed("move_fwd")
	move_back = event.is_action_pressed("move_back")
	if event.is_action_pressed("move_left"):
		move_left = true
	elif event.is_action_released("move_left"):
		move_left = false
	if event.is_action_pressed("move_right"):
		move_right = true
	elif event.is_action_released("move_right"):
		move_right = false
	if event.is_action_pressed("jump"):
		jump = true
	elif event.is_action_released("jump"):
		jump = false
	if event.is_action_pressed("crouch"):
		crouch = true
	elif event.is_action_released("crouch"):
		crouch = false
	if event.is_action_pressed("rotate_left"):
		rotate_left = true
	elif event.is_action_released("rotate_left"):
		rotate_left = false
	if event.is_action_pressed("rotate_right"):
		rotate_right = true
	elif event.is_action_released("rotate_right"):
		rotate_right = false

	if event.is_action_pressed("sprint_boost"):
		sprint_boost = true
	elif event.is_action_released("sprint_boost"):
		sprint_boost = false
	
	if event.is_action_released("jetpack", true):
		jetpack_input = true
	if event.is_action_released("inertiaDampener", true):
		inertiaDampener = true
