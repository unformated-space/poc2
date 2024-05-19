class_name Movement_controller
extends Node
#@onready var camera_contrsoller = get_node("./CameraController")

@export var cammera_scene : String
var rigid = RigidBody3D
var camera
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

func _init(body : RigidBody3D, exported_camera):
	rigid = body
	camera = exported_camera

func apply_rotation(quat):
	var new_basis = Basis(quat) * rigid.global_transform.basis
	rigid.global_transform.basis = new_basis

## FIXME: check if player_jetpacking is the best way or pass an available movemet angles based on trhusters available
func handle_movement(direction, player_jetpacking: bool = false):
	var rotation_speed = 0.01
	var quatz := Quaternion.IDENTITY
	#if direction == Vector3.ZERO:
	if move_fwd:
		direction += -rigid.transform.basis.z
	if move_back:
		direction += rigid.transform.basis.z
	if move_left:
		direction += -rigid.transform.basis.x
	if move_right:
		direction += rigid.transform.basis.x
	if player_jetpacking:
		if jump:
			direction += rigid.transform.basis.y
		if crouch:
			direction += -rigid.transform.basis.y
			
		quatz *= Quaternion(rigid.transform.basis.x,camera.camera_angle_z)
		if rotate_left:
			quatz *= Quaternion(rigid.transform.basis.z, rotation_speed)  # Rotate around local z-axis
		elif rotate_right:
			quatz *= Quaternion(rigid.transform.basis.z, -rotation_speed)
		apply_rotation(quatz)
	apply_rotation(Quaternion(rigid.transform.basis.y, camera.camera_angle_y)*quatz)
	camera.camera_angle_y = 0.0
	camera.camera_angle_z = 0.0
	return direction



func apply_movement(direction, speed):
	if direction.length() > 0:
		direction = direction.normalized() * speed
	rigid.apply_central_force(direction * power)

	var current_velocity = rigid.linear_velocity
	var current_speed = current_velocity.length()
	if current_speed > speed:
		current_velocity = current_velocity.normalized() * speed
		rigid.linear_velocity = current_velocity
#
func dampenersContrls():
	dampeners = !dampeners
	if dampeners:
		rigid.linear_damp = 2
	else:
		rigid.linear_damp = 0

func align_to_gravity_direction(delta):
	rigid.rotation.z = lerp( rigid.rotation.z ,0.0, delta * Config.lerpSpeed)
	rigid.rotation.x = lerp( rigid.rotation.x ,0.0, delta * Config.lerpSpeed)


func tata(event):
	if event.is_action_pressed("move_fwd"):
		move_fwd = true
	elif event.is_action_released("move_fwd"):
		move_fwd = false
	if event.is_action_pressed("move_back"):
		move_back = true
	elif event.is_action_released("move_back"):
		move_back = false
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
