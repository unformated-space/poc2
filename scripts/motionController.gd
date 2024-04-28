# InputManager.gd
extends RigidBody3D

@export var  inVehicle := false
var twist_input := 0.0
var pitch_input := 0.0

#func _ready():
	#lock_rotation = true

	
@onready var camera_controller = get_node("./CameraController")
var move_input :=Vector3.ZERO
var velocity := Vector3.ZERO
var acceleration = 0.5
var accel_multiplier = 3.0
var max_speed = 9.0
var sprint_speed = 12.0
var normal_speed = 7.0
# Handle input events

var jetpack := false
var dampeners := true
var jumping := false
@onready var ray_cast_3d = $RayCast3D

@onready var text = get_node("../../GUI/log")
@onready var speedLabel = get_node("../../GUI/speed")
@onready var dampenerLabel = get_node("../../GUI/dampeners")
@onready var jetpackLabel = get_node("../../GUI/jetpack")
func _ready():
	text.scroll_following=true
	lock_rotation=true
	# Damping can be set to simulate air resistance, if needed

	
	# Other properties you might want to configure
	#friction = 1.0  # Adjust friction to control sliding behavior
	#bounce = 0.0  # No bounce; adjust as necessary for your simulation needs

func is_on_floor() -> bool:
	return $RayCast3D.is_colliding()

	
func _process(delta):
	#text.append_text(str(camera_controller.cameraAngle)+"\n")
	var speed_m_s = linear_velocity.length()  # This is the speed in meters per second
	speedLabel.text="Speed: " + str(speed_m_s) + " m/s"
	dampenerLabel.text="Dampeners "+str(dampeners)
	jetpackLabel.text = "jetpack "+str(jetpack)
	pass
func _physics_process(delta):
	rotate_y(camera_controller.cameraAngle)
	camera_controller.cameraAngle = 0.0
	var speed = 0.0
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_fwd"):
		direction += -transform.basis.z
	if Input.is_action_pressed("move_back"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction += -transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	if jetpack:
		if Input.is_action_pressed("jump"):
			direction += transform.basis.y
		if Input.is_action_pressed("crouch"):
			direction += -transform.basis.y
		if Input.is_action_pressed("rotate_left"):
			rotate_z( deg_to_rad(lerp( position.z ,position.z, delta * Config.lerpSpeed)))
		if Input.is_action_pressed("rotate_right"):
			rotate_z( -deg_to_rad(lerp( position.z ,position.z, delta * Config.lerpSpeed)))
		rotate_x(camera_controller.cameraAngleZ)
		camera_controller.cameraAngleZ = 0.0

	
	# TODO: add crouching
	# TODO: fix jump
	if Input.is_action_pressed("jump") && !jumping:
		direction.y += 50
		jumping = true
		
	if Input.is_action_pressed("sprint-boost"):
		speed = sprint_speed
	else:
		speed = normal_speed
		
	if Input.is_action_just_released("jetpack"):
		jetpack = !jetpack

	if Input.is_action_just_released("inertiaDampener"):
		dampeners = !dampeners

	if jetpack:
		speed *=1.5
		if dampeners:
			linear_damp = 5
		else:
			linear_damp = 1
		gravity_scale = 0
	else:
		rotation.z = lerp( rotation.z ,0.0, delta * Config.lerpSpeed)
		rotation.x = lerp( rotation.x ,0.0, delta * Config.lerpSpeed)
		
		gravity_scale = 1
		linear_damp = 0
	#text.append_text(str(linear_damp)+"\n")
	#
	
	if direction.length() > 0:
		direction = direction.normalized() * speed


	apply_central_force(direction * 10)
	# Limit the maximum speed
	var current_speed = linear_velocity.length()
	var max_speed = 100  # Change this value to your desired maximum speed
	

	
	if current_speed > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
