extends Movement_controller
@onready var capsule = get_node("./CollisionShape3D").shape
@export_range(0, 1, 0.01) var walkable_normal : float # 0.35 # Walkable slope. Lower is steeper
@onready var collision_shape_3d = $CollisionShape3D
@onready var speed_ui = get_node(Config.chat_log)

var move_input := Vector3.ZERO
var velocity := Vector3.ZERO
var acceleration = 0.5
var accel_multiplier = 3.0
var crouching_speed = 4.0
var sprint_speed = 12.0
var normal_speed = 7.0
var upper_slope_normal: Vector3 # Stores the lowest (steepest) slope normal
var lower_slope_normal: Vector3 # Stores the highest (flattest) slope normal
var slope_normal: Vector3 # Stores normals of contact points for iteration
var contacted_body: RigidBody3D # Rigid body the player is currently contacting, if there is one
var jumping := false
var jetpack := false
var player_is_grounded: bool = true
var is_grounded := true
var max_slope_angle_degrees := 45
var physics_state
func _ready():
	#text.scroll_following = true
	lock_rotation = true
	#on_ready()

func _process(_delta):
	var speed_m_s = linear_velocity.length()
	#speed_ui.append_text("Speed "+str(speed_m_s)+"\n")
	if Input.is_action_just_released("jetpack"):
		jetpack = !jetpack
		print("jetpack")
	if Input.is_action_just_released("inertiaDampener"):
		dampenersContrls()
		#speed_ui.append_text("dampeners"  + str(dampeners)+"\n")
func _integrate_forces(state):
	physics_state = state

func _physics_process(delta):
	if player_is_grounded or jetpack:  # Comprobar si el jugador puede moverse
		var direction = handle_movement(Vector3.ZERO, jetpack)
		var speed = handle_speed()
		if jetpack:
			gravity_scale = 0
			apply_movement(direction, speed)
		else:
			gravity_scale = 1
			linear_damp = 2
			align_to_gravity_direction(delta)
			if not detect_ground().is_on_ground:
				velocity.y += gravity * delta
			else:
				velocity.y = max(velocity.y, 0) 
			apply_movement(direction, speed)
	var ground_data = detect_ground()
	if ground_data["is_on_ground"]:
		handle_slopes(physics_state, max_slope_angle_degrees, ground_data)
		print("Ground Normal: ", ground_data["ground_normal"])


#func _integrate_forces(state):
	#print (state)
	##player_is_grounded = generate_slope_raycasts(state)
	#contacted_body = null # Rigidbody
	## Velocity of the Rigidbody the player is contacting
	#var contacted_body_vel_at_point = Vector3()

func is_walkable(normal):
	return (normal >= walkable_normal) # Lower normal means steeper slope

func maintain_current_state():
	if not player_is_grounded and not jetpack:
		apply_central_force(Vector3(0, 1 * mass, 9.8))  # Asegurando que la gravedad sigue aplicándose

func handle_speed():
	if jetpack:
		return 20
	else:
		if Input.is_action_pressed("sprint-boost"):
			return 30
		elif Input.is_action_pressed("crouch"):
			return 15
		else:
			return 20

func handle_slopes(state, max_slope_angle_degrees: float, ground_data):
	var max_slope_angle_radians = deg_to_rad(max_slope_angle_degrees)
	var found_slope = false
	var normal = Vector3.UP  # Default normal

	for i in range(ground_data["collision_statuses"].size()):
		if ground_data["collision_statuses"][i]:
			var raycast = get_child(i)
			if raycast is RayCast3D:
				var possible_normal = raycast.get_collision_normal()
				var angle = acos(possible_normal.dot(Vector3.UP))
				
				if angle <= max_slope_angle_radians:
					normal = possible_normal
					found_slope = true
					break

	if found_slope:
		var velocity = state.linear_velocity
		velocity = velocity.slide(normal)
		state.linear_velocity = velocity

# Detects ground using 9 raycasts: 8 in a circle and 1 downward
func detect_ground():
	var results = {
		"is_on_ground": false,
		"ground_normal": Vector3.UP,
		"collision_statuses": []
	}
	
	for raycast in get_children():
		if raycast is RayCast3D:
			var is_colliding = raycast.is_colliding()
			results.collision_statuses.append(is_colliding)
			if is_colliding and raycast.get_name() == "CenterRaycast":
				results["is_on_ground"] = true
				results["ground_normal"] = raycast.get_collision_normal()
				
	return results

