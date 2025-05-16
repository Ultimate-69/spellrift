extends Node

const SAVE_PATH = "user://save.spell"
const PASSWORD = "9fa!DN49D+rBS^Hdap2^Ce&!WD^uxaRSj3f#UfdFHdgQ7EgY)g)d4YbTamB$J#TY"

var save_dict: Dictionary[String, Variant] = {
	Test = 1,
	Name = "Hello!"
}

func save_game() -> void:
	var file = FileAccess.open_encrypted_with_pass(SAVE_PATH,
	 FileAccess.WRITE, PASSWORD)
	
	file.store_string(JSON.stringify(save_dict))
	file.close()

# returns 1 if no save, 2 if failed to load, else returns data dictionary.
func load_game():
	var file = FileAccess.open_encrypted_with_pass(SAVE_PATH,
	 FileAccess.READ, PASSWORD)
	
	if file == null:
		if FileAccess.get_open_error() == ERR_FILE_NOT_FOUND:
			# no file found
			return 1
		else:
			# other error that stopped from opening file
			return 2
	else:
		var data: Dictionary[String, Variant] = JSON.parse_string(file.get_as_text())
		file.close()
		return data
