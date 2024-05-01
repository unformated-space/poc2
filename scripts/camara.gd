extends Node3D
class_name CameraManager

@export var controller: RigidBody3D

@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D
@onready var camera_controller = $"."

@export var camera_angle_y: float = 0.0
@export var camera_angle_z: float = 0.0
@export var free_look_tilt: float = 8.0

var in_first_person := true
var free_looking := false
var spring_arm_length: float = 3.0
var origin_camera_x: float = 0.0
var switch_view_delta_key: float = 0.0
var centering_camera := false
var lerp_factor: float = 0.0

@onready var text: RichTextLabel = get_node("../../../GUI/log")

func _ready():
	pass

func _process (delta):
	#if controller not = null && typeof(controller) == 24 && not in_first_person:
		#spring_arm_3d.add_excluded_object(controller)

	#text.append_text(str(origin_camera_x)+","+str(spring_arm_3d.rotation.x)+","+str(centering_camera)+"\n")
	free_looking = false
	#managing the lengh of the spring in third person
	if in_first_person:
		spring_arm_3d.spring_length=0.0
	else:
		spring_arm_3d.spring_length = spring_arm_length
	
	if (switch_view_delta_key > 0.0):
		switch_view_delta_key += delta
	if (switch_view_delta_key > 0.3):
		switch_view_delta_key = 0.0

	#switch view
	if Input.is_action_just_released("switchView"):		
		in_first_person = not in_first_person
	if Input.is_action_just_pressed("freeLook"):
		if (switch_view_delta_key > 0.0 && switch_view_delta_key < 0.25) || in_first_person	:
			origin_camera_x = spring_arm_3d.rotation.x
			switch_view_delta_key = 0.0
			lerp_factor = 0.0
			centering_camera = true
		if switch_view_delta_key == 0.0:
			switch_view_delta_key = delta
		free_looking = false
	if Input.is_action_pressed("freeLook"):
		free_looking = true

	#when stop free_looking center camera forward
	if (in_first_person && not free_looking) || (not in_first_person && centering_camera):
		if (centering_camera):
			lerp_factor += delta * Config.lerpSpeed
			#camera_controller.rotation.x = lerp(camera_controller.rotation.x, origin_camera_x, lerp_factor*1.5)
			camera_controller.rotation.y = lerp(camera_controller.rotation.y, 0.0, lerp_factor)
			spring_arm_3d.rotation.z = lerp(spring_arm_3d.rotation.z, 0.0, lerp_factor)
			if (lerp_factor >= 1.0):
				centering_camera = false
	# TODO: fix centering the camera to the original x position before freelooking, it only works once
		#if origin_camera_x not = spring_arm_3d.rotation.x && centering_camera :
			#centering_camera = true
			#spring_arm_3d.rotation.x = lerp(spring_arm_3d.rotation.x,origin_camera_x, delta * Config.lerpSpeed)
		#else:
			#centering_camera = false

func _input(event): 
	if event is InputEventMouseMotion:
		if free_looking:
			camera_controller.rotate_y (-deg_to_rad(event.relative.x * Config.mouseSens))
			spring_arm_3d.rotate_x (-deg_to_rad(event.relative.y * (Config.mouseSens*0.5)))
			spring_arm_3d.rotation.x = clamp (spring_arm_3d.rotation.x, deg_to_rad(-45),deg_to_rad(80))
			if in_first_person:
				camera_controller.rotation.y = clamp (camera_controller.rotation.y, deg_to_rad(-120),deg_to_rad(120))
				spring_arm_3d.rotation.z = -deg_to_rad(camera_controller.rotation.y * free_look_tilt)
		else:
			camera_angle_y = (-deg_to_rad(event.relative.x * (Config.mouseSens*0.5)))
			camera_angle_z = (-deg_to_rad(event.relative.y * (Config.mouseSens*0.5)))
		#if in_first_person || (not in_first_person&&free_looking):
		if in_first_person || (not in_first_person&&free_looking):
			#camera_controller.rotate_y (-deg_to_rad(event.relative.x * (Config.mouseSens*0.5)))
			#camera_controller.rotation.y = clamp (camera_controller.rotation.y, deg_to_rad(-45),deg_to_rad(80))
			spring_arm_3d.rotate_x (-deg_to_rad(event.relative.y * (Config.mouseSens*0.5)))
			spring_arm_3d.rotation.x = clamp (spring_arm_3d.rotation.x, deg_to_rad(-45),deg_to_rad(80))

	if event is InputEventMouseButton:
		if not in_first_person && free_looking:
			if event.button_index == 4:
				spring_arm_length -= 0.1
			elif event.button_index == 5:
				spring_arm_length += 0.1
			spring_arm_length=clamp (spring_arm_length, 1.2 , 10.0)
			spring_arm_3d.spring_length=spring_arm_length


