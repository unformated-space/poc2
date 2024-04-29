extends Interactable
@onready var mesh_instance_3d = $MeshInstance3D
@onready var text: RichTextLabel = get_node("../../GUI/log")
func _interact():
	DebugConsole.log("me tocaron el culo")
	text.append_text("me tocaron el culo\n")
