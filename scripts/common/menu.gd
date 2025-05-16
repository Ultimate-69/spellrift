extends Control

@onready var version: Label = $Version

func _ready() -> void:
	version.text = Globals.VERSION_NUM
	
	var save_data: Variant = SaveManager.load_game()
	if save_data == 1:
		# no save
		SaveManager.save_game()
		pass
	elif save_data == 2:
		NotificationManager.send_notification(
			"Failed to load save data. Please try restarting the game.", 
			"Save Load Fail")
	else:
		# got data safely
		pass
