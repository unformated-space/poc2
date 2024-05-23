extends RigidBody3D

@export var cammera_scene : Node3D

@onready var motion_controller = Movement_controller.new(self, cammera_scene)

var velocity := Vector3.ZERO
var crouching_speed = 4.0
var sprint_speed = 12.0
var normal_speed = 7.0
var jetpack := false
var player_is_grounded: bool = true
var max_slope_angle_degrees := 80
var physics_state

func _ready():
	#text.scroll_following = true
	lock_rotation = true
	motion_controller.power_z += 1000
	#on_ready()

func _process(_delta):
	#var speed_m_s = linear_velocity.length()
	if motion_controller.jetpack_input:
		jetpack = !jetpack
	if motion_controller.inertiaDampener:
		motion_controller.dampenersContrls()
	motion_controller.jetpack_input =  false
	motion_controller.inertiaDampener = false
	
func _integrate_forces(state):
	physics_state = state

func _physics_process(delta):
	if player_is_grounded or jetpack:  # Comprobar si el jugador puede moverse
		var speed = handle_speed()
		if jetpack:
			gravity_scale = 0
			motion_controller.handle_movement(Vector3.ZERO, speed, jetpack)
		else:
			gravity_scale = 1
			linear_damp = 2
			motion_controller.align_to_gravity_direction(delta)
			if not detect_ground().is_on_ground:
				velocity.y += motion_controller.gravity * delta
			else:
				velocity.y = max(velocity.y, 0) 
			motion_controller.handle_movement(Vector3.ZERO, speed, jetpack)
	var ground_data = detect_ground()
	if ground_data["is_on_ground"]:
		handle_slopes(physics_state, max_slope_angle_degrees, ground_data)
		print("Ground Normal: ", ground_data["ground_normal"])

func handle_speed():
	if jetpack:
		return 20
	else:
		if motion_controller.sprint_boost:
			return 30
		elif motion_controller.crouch:
			return 15
		else:
			return 20

func handle_slopes(state, max_slopes_deg: float, ground_data):
	var max_slope_angle_radians = deg_to_rad(max_slopes_deg)
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
		var velocity_slope = state.linear_velocity
		state.linear_velocity = velocity_slope.slide(normal)

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

func _unhandled_input(event):
	motion_controller.tata(event)
