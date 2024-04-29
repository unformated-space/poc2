extends RigidBody3D

@export var inVehicle := false
var twist_input := 0.0
var pitch_input := 0.0

@onready var camera_controller = get_node("./CameraController")
var move_input := Vector3.ZERO
var velocity := Vector3.ZERO
var acceleration = 0.5
var accel_multiplier = 3.0
var max_speed = 12.0
var sprint_speed = 12.0
var normal_speed = 7.0
var align_to_gravity = false
var gravity_align_speed = 2.0 

var jetpack := false
var dampeners := true
var jumping := false
@onready var ray_cast_3d = $RayCast3D

@onready var text = get_node("../../GUI/log")
@onready var speedLabel = get_node("../../GUI/speed")
@onready var dampenerLabel = get_node("../../GUI/dampeners")
@onready var jetpackLabel = get_node("../../GUI/jetpack")

func _ready():
	text.scroll_following = true
	lock_rotation = true

func is_on_floor() -> bool:
	return $RayCast3D.is_colliding()
	
func can_move() -> bool:
	# Definir las condiciones bajo las cuales el movimiento está permitido o bloqueado
	return is_on_floor() or jetpack

func maintain_current_state():
	# Aquí puedes definir lo que sucede cuando los inputs están bloqueados
	# Por ejemplo, mantener la velocidad actual o aplicar una fuerza de gravedad si está en el aire
	
	if not is_on_floor() and not jetpack:
		apply_central_force(Vector3(0, 1 * mass, 9.8))  # Asegurando que la gravedad sigue aplicándose


func _process(delta):
	var speed_m_s = linear_velocity.length()  # This is the speed in meters per second
	speedLabel.text = "Speed: " + str(speed_m_s) + " m/s"
	dampenerLabel.text = "Dampeners " + str(dampeners)
	jetpackLabel.text = "Jetpack " + str(jetpack)
	text.append_text(str(is_on_floor())+"\n")


func _physics_process(delta):
	rotate_y(camera_controller.cameraAngle)
	#rotation.y += deg_to_rad(camera_controller.cameraAngle * 15)
	camera_controller.cameraAngle = 0.0

	if can_move():  # Comprobar si el jugador puede moverse
		var direction = handle_movement_input(Vector3.ZERO, delta)
		var speed = handle_speed_input()
		apply_movement(direction, speed, delta)
	else:
		maintain_current_state()
		align_to_gravity_direction(delta)



func handle_movement_input(direction, delta):
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
		rotate_x(camera_controller.cameraAngleZ)
		camera_controller.cameraAngleZ = 0.0
	return direction

func handle_speed_input():
	if Input.is_action_just_released("jetpack"):
		jetpack = !jetpack
	if Input.is_action_just_released("inertiaDampener"):
		dampeners = !dampeners

	if jetpack:
		if dampeners:
			linear_damp = 5
		else:
			linear_damp = 1
		gravity_scale = 0
		return 20
	else:
		align_to_gravity = true
		gravity_scale = 1
		linear_damp = 0
		if Input.is_action_pressed("sprint-boost"):
			return sprint_speed
		else:
			return normal_speed


func apply_movement(direction, speed, delta):
	if direction.length() > 0:
		direction = direction.normalized() * speed
	apply_central_force(direction * 100)

	var current_velocity = linear_velocity
	var current_speed = current_velocity.length()
	if current_speed > speed:
		current_velocity = current_velocity.normalized() * speed
		linear_velocity = current_velocity
	if jetpack:
		if Input.is_action_pressed("rotate_left"):
			rotate_z(deg_to_rad(-1))  # Rotar a una velocidad fija por frame
		if Input.is_action_pressed("rotate_right"):
			rotate_z(deg_to_rad(1))  # Rotar a una velocidad fija por frame




func align_to_gravity_direction(delta):
	rotation.z = lerp( rotation.z ,0.0, delta * Config.lerpSpeed)
	rotation.x = lerp( rotation.x ,0.0, delta * Config.lerpSpeed)
