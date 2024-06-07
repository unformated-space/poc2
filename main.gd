extends Node3D

#@onready var label = $GUI/Label

var peer = ENetMultiplayerPeer.new()



func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		
		#delete_player(id)
		get_tree().quit()

	##label.set_tex wx wawxxt("FPS "+str(Engine.get_frames_per_second()))
	#
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


	peer.create_client("localhost", 12345)
	multiplayer.multiplayer_peer =  peer
	var login_response = login()
	if login_response:
		Globals.clientUUID = login_response
	


func login():
	return "UUID"+str(ResourceUID.create_id())
#func _unhandled_input(event):
	#if event is InputEventKey:
		#if event.pressed and event.scancode == KEY_ESCAPE:
			#get_tree().quit()

@rpc ("any_peer", "call_local")
func add_player (id=1): 
	print("player added")


@rpc ("any_peer", "call_local")
func delete_player (id=1):
	get_node(str(id)).queue_free()
	print("player removed")
