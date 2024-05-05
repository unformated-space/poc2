class_name Movement_controller
extends RigidBody3D

#@onready var camera_contrsoller = get_node("./CameraController")
@onready var chat_log = get_node(Config.chat_log)

@export var camera_controller: Node3D
@onready var camera = get_node(camera_controller.get_path())
var global_max_speed = 70.0 # Max Global speed (100 se style for testing)

var align_to_gravity = false
var gravity_align_speed = 2.0 
var gravity := 9.8
var dampeners := true
var power := 100
func on_ready():
	print(str(camera))


	#speed when is needed must be an export
	#var speed_m_s = linear_velocity.length()  # This is the speed in meters per second


func apply_rotation(quat):
	var new_basis = Basis(quat) * global_transform.basis
	global_transform.basis = new_basis


## FIXME: check if player_jetpacking is the best way or pass an available movemet angles based on trhusters available
func handle_movement(direction, player_jetpacking: bool = false):
	var rotation_speed = 0.01
	var quatz := Quaternion.IDENTITY
	#if direction == Vector3.ZERO:
	if Input.is_action_pressed("move_fwd"):
		direction += -transform.basis.z
	if Input.is_action_pressed("move_back"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction += -transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	if player_jetpacking:
		if Input.is_action_pressed("jump"):
			direction += transform.basis.y
		if Input.is_action_pressed("crouch"):
			direction += -transform.basis.y
			
		quatz *= Quaternion(transform.basis.x,camera.camera_angle_z)
		if Input.is_action_pressed("rotate_left"):
			quatz *= Quaternion(transform.basis.z, rotation_speed)  # Rotate around local z-axis
		elif Input.is_action_pressed("rotate_right"):
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
	#apply_central_impulse(impulse)
#func apply_movement(direction, speed):
	#direction = direction.normalized()
	#var velocity_change = direction * speed
	#apply_central_impulse(velocity_change * mass)
	### Debug output to help track values and behavior
	##print("Direction: ", direction, " Speed: ", speed)
	##print("Delta: ", delta, " Acceleration: ", acceleration)
	##print("Velocity Change: ", velocity_change, " New Velocity: ", new_velocity)
	##print("Impulse: ", impulse, " Linear Velocity: ", linear_velocity)


func dampenersContrls():
	dampeners = !dampeners
	if dampeners:
		linear_damp = 4
	else:
		linear_damp = 0

func align_to_gravity_direction(delta):
	rotation.z = lerp( rotation.z ,0.0, delta * Config.lerpSpeed)
	rotation.x = lerp( rotation.x ,0.0, delta * Config.lerpSpeed)



