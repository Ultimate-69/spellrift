extends Control

@onready var ui_navigator: UINavigator = $UINavigator

@export var shader: ShaderMaterial

@onready var version: Label = $Version

@onready var continue_button: Button = $VBoxContainer/CenterContainer/Continue
@onready var new_button: Button = $VBoxContainer/CenterContainer2/New
@onready var settings_button: Button = $VBoxContainer/CenterContainer3/Settings
@onready var credits_button: Button = $VBoxContainer/CenterContainer4/Credits
@onready var quit_button: Button = $VBoxContainer/CenterContainer5/Quit

@onready var ui_panels: Node = $UIPanels
@onready var credits_panel: Panel = $UIPanels/Credits

@onready var cancel_sound: AudioStreamPlayer = $CancelSound

var last_focus_button: Control

func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action("ui_cancel"):
        for panel: Panel in ui_panels.get_children():
            if panel.visible:
                cancel_sound.play()
            panel.visible = false
            if last_focus_button:
                last_focus_button.grab_focus()
            ui_navigator.visible = true

func _ready() -> void:
    connect_signals()
    shader.set_shader_parameter("colour_1", Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 1))
    
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
    else:
        await get_tree().create_timer(0.01).timeout
        quit_button.grab_focus()
        continue_button.grab_focus()
        
func connect_signals() -> void:
    quit_button.pressed.connect(func():
        get_tree().quit()
    )
    
    new_button.pressed.connect(func():
        get_tree().change_scene_to_file("res://scenes/arenas/testing_grounds.tscn")
    )
    
    settings_button.pressed.connect(func():
        last_focus_button = get_viewport().gui_get_focus_owner()
        $UIPanels/Settings.visible = true
        $UIPanels/Settings/VolumeSlider.grab_focus()
        ui_navigator.visible = false
    )
    
    credits_button.pressed.connect(func():
        last_focus_button = get_viewport().gui_get_focus_owner()
        credits_panel.visible = true
        $UIPanels/Credits/ScrollContainer.grab_focus()
        ui_navigator.visible = false
    )


func _on_volume_slider_drag_ended(value_changed: bool) -> void:
    if value_changed:
        AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),
         $UIPanels/Settings/VolumeSlider.value - 70)


func _on_window_options_item_selected(index: int) -> void:
    if index == 0:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
    elif index == 1:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    elif index == 2:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
