extends Control

@onready var version: Label = $Version

@onready var continue_button: Button = $VBoxContainer/CenterContainer/Continue
@onready var new_button: Button = $VBoxContainer/CenterContainer2/New
@onready var settings_button: Button = $VBoxContainer/CenterContainer3/Settings
@onready var credits_button: Button = $VBoxContainer/CenterContainer4/Credits
@onready var quit_button: Button = $VBoxContainer/CenterContainer5/Quit

func _ready() -> void:
	connect_signals()
	
	version.text = Globals.VERSION_NUM
	continue_button.grab_focus()
	
	var save_data = SaveManager.load_game()
	if save_data is not Dictionary:
		if save_data == 1:
			# no save
			SaveManager.save_game()
		elif save_data == 2:
			NotificationManager.send_notification(
				"Failed to load save data. Please try restarting the game.", 
				"Save Load Fail")
				
	continue_button.visible = SaveManager.save_dict["is_in_run"]
	if not continue_button.visible:
		new_button.grab_focus()
		quit_button.focus_neighbor_bottom = new_button.get_path()
		new_button.focus_neighbor_top = quit_button.get_path()
		await get_tree().create_timer(0.01).timeout
		quit_button.grab_focus()
		new_button.grab_focus()
		
func connect_signals() -> void:
	quit_button.pressed.connect(func():
		get_tree().quit()
	)
