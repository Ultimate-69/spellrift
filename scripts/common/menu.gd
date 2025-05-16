extends Control

func _ready() -> void:
	var save_data: Variant = SaveManager.load_game()
	if save_data == 1:
		pass
	elif save_data == 2:
		NotificationManager.send_notification(
			"Failed to load save data. Please try restarting the game.", 
			"Save Load Fail")
	else:
		# got data safely
		pass
