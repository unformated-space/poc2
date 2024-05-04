extends Movement_controller
@onready var capsule = get_node("./CollisionShape3D").shape
@export_range(0, 1, 0.01) var walkable_normal : float # 0.35 # Walkable slope. Lower is steeper
@onready var collision_shape_3d = $CollisionShape3D

var move_input := Vector3.ZERO
var velocity := Vector3.ZERO
var acceleration = 0.5
var accel_multiplier = 3.0

var sprint_speed = 12.0
var normal_speed = 7.0
var upper_slope_normal: Vector3 # Stores the lowest (steepest) slope normal
var lower_slope_normal: Vector3 # Stores the highest (flattest) slope normal
var slope_normal: Vector3 # Stores normals of contact points for iteration
var contacted_body: RigidBody3D # Rigid body the player is currently contacting, if there is one
var jumping := false
var jetpack := false
var player_is_grounded: bool = true

func _ready():
	#text.scroll_following = true
	lock_rotation = true
	on_ready()

func _process(_delta):
	if Input.is_action_just_released("jetpack"):
		jetpack = !jetpack
	if Input.is_action_just_released("inertiaDampener"):
		dampeners = !dampeners
		print("dampeners")
		
func _physics_process(delta):
	print ("logs")
	if player_is_grounded or jetpack:  # Comprobar si el jugador puede moverse
		var direction = handle_movement(Vector3.ZERO, jetpack)
		var speed = handle_speed_input(global_max_speed)
		apply_movement(direction, speed)
	else:
		maintain_current_state()
		align_to_gravity_direction(delta)
	#var direction = handle_movement(Vector3.ZERO, jetpack)
	#var speed = handle_speed_input(global_max_speed)
	#apply_movement(direction, speed)
	#align_to_gravity_direction(delta)

func _integrate_forces(state):
	print (state)
	player_is_grounded = generate_slope_raycasts(state)
	contacted_body = null # Rigidbody
	# Velocity of the Rigidbody the player is contacting
	var contacted_body_vel_at_point = Vector3()
	
	
func generate_slope_raycasts(state):
	var is_grounded : bool = false
	var raycast_list = Array() # List of raycasts used with detecting groundedness
	var bottom = 0.1 # 0.1 Distance down from start to fire the raycast to
	var start = (capsule.height/2 + capsule.radius)-0.05 # -0.05 Start point down from the center of the player to start the raycast
	var cv_dist = capsule.radius-0.1 # -0.1 Cardinal vector distance.
	var ov_dist = cv_dist/sqrt(2) # Ordinal vector distance. Added to 2 cardinal vectors to result in a diagonal with the same magnitude of the cardinal vectors
	# Get world state for collisions
	var contacted_body_vel_at_point = Vector3()
	var direct_state = get_world_3d().direct_space_state
	raycast_list.clear()
	is_grounded = false
	# Create 9 raycasts around the player capsule.
	# They begin towards the edge of the radius and shoot from just
	# below the capsule, to just below the bottom bound of the capsule,
	# with one raycast down from the center.
	for i in 9:
		# Get the starting location
		var loc = self.position
		# subtract a distance to get below the capsule
		loc.y -= start
		# Create the distance from the capsule center in a certain direction
		match i:
			# Cardinal vectors
			0: 
				loc.z -= cv_dist # N
			1:
				loc.z += cv_dist # S
			2:
				loc.x += cv_dist # E
			3:
				loc.x -= cv_dist # W
			# Ordinal vectors
			4:
				loc.z -= ov_dist # NE
				loc.x += ov_dist
			5:
				loc.z += ov_dist # SE
				loc.x += ov_dist	
			6:
				loc.z -= ov_dist # NW
				
				loc.x -= ov_dist
			7:
				loc.z += ov_dist # SW
				loc.x -= ov_dist
		# Copy the current location below the capsule and subtract from it
		var loc2 = loc
		loc2.y -= bottom
		# Add the two points for this iteration to the list for the raycast
		raycast_list.append([loc,loc2])
	# Check each raycast for collision, ignoring the capsule itself
	for array in raycast_list:
		var direct_query_parameters = PhysicsRayQueryParameters3D.create(array[0],array[1], 0x00000005,[self])
		var collision = direct_state.intersect_ray(direct_query_parameters)
		# The player is grounded if any of the raycasts hit 2
		if (collision and is_walkable(collision.normal.y)):
			is_grounded = true
#### Grounding, slopes, & rigidbody contact point
	## If the player body is contacting something
	#var shallowest_contact_index: int = -1
	#upper_slope_normal = Vector3(0,1,0)
	#lower_slope_normal = Vector3(0,-1,0)
	#if (state.get_contact_count() > 0):
		## Iterate over the capsule contact points and get the steepest/shallowest slopes
		#for i in state.get_contact_count():
			#slope_normal = state.get_contact_local_normal(i)
			#if (slope_normal.y < upper_slope_normal.y): # Lower normal means steeper slope
				#upper_slope_normal = slope_normal
			#if (slope_normal.y > lower_slope_normal.y):
				#lower_slope_normal = slope_normal
				#shallowest_contact_index = i
		## If the steepest slope contacted is more shallow than the walkable_normal, the player is grounded
		#if (is_walkable(upper_slope_normal.y)):
			#is_grounded = true
			## If the shallowest contact index exists, get the velocity of the body at the contacted point
			#if (shallowest_contact_index >= 0):
				#var contact_position = state.get_contact_collider_position(0) # coords of the contact point from center of contacted body
				#var collisions = get_colliding_bodies()
				#if (collisions.size() > 0 and collisions[0].get_class() == "RigidBody"):
					#contacted_body = collisions[0]
					#contacted_body_vel_at_point = get_contacted_body_velocity_at_point(contacted_body, contact_position)
		## Else if the shallowest slope normal is not walkable, the player is not grounded
		#elif (!is_walkable(lower_slope_normal.y)):
			#is_grounded = false
	return is_grounded
# Whether a slope is walkable



func is_walkable(normal):
	return (normal >= walkable_normal) # Lower normal means steeper slope
func maintain_current_state():
	if player_is_grounded and not jetpack:
		apply_central_force(Vector3(0, 1 * mass, 9.8))  # Asegurando que la gravedad sigue aplicándose

func handle_speed_input(max_speed):
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
		linear_damp = 1
		if Input.is_action_pressed("sprint-boost"):
			return sprint_speed
		else:
			return normal_speed

func get_contacted_body_velocity_at_point(contacted_body: RigidBody3D, contact_position: Vector3):
	# Global coordinates of contacted body
	var body_position = contacted_body.transform.origin
	# Global coordinates of the point of contact between the player and contacted body
	var global_contact_position = body_position + contact_position
	# Calculate local velocity at point (cross product of angular velocity and contact position vectors)
	var local_vel_at_point = contacted_body.get_angular_velocity().cross(global_contact_position - body_position)
	# Add the current velocity of the contacted body to the velocity at the contacted point
	return contacted_body.get_linear_velocity() + local_vel_at_point

