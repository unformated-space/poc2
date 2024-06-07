extends Node

var object_state = {
	"position": Vector2.ZERO,
	"health": 100,
	"inventory": []
}
#var data := JSON.new()



# Guarda el estado del objeto en un archivo
func save_state(file_path: String, data):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if true: #add test
		file.store_string(JSON.stringify(data))
		file.close()
	else:
		print("Error al abrir el archivo para guardar")

func load_state(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	var data
	if true:
		data = JSON.parse_string(file.get_as_text)
		file.close()
	else:
		print("Error al abrir el archivo para guardar")
		data = false
	return data
