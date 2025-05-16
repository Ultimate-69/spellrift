@icon("res://assets/images/navigation_e.svg")
class_name UINavigator extends Control

@export var cursor_offset: int = 40

@export var button_container: Container

@onready var move_sound: AudioStreamPlayer = $MoveSound
@onready var click_sound: AudioStreamPlayer = $ClickSound

var cursor: TextureRect
var focus: Control
var tween: Tween

func _ready() -> void:
	cursor = TextureRect.new()
	cursor.set_anchors_preset(Control.PRESET_FULL_RECT)
	cursor.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	cursor.texture = load("res://assets/images/navigation_e.svg")
	add_child(cursor)
	
	get_viewport().gui_focus_changed.connect(set_focus)
	
	for container: CenterContainer in button_container.get_children():
		var button: Button = container.get_children()[0]
		button.focus_entered.connect(move_cursor_to_button)
		button.mouse_entered.connect(func ():
			button.grab_focus()
		)
		button.pressed.connect(play_click)
		
	swing_cursor()
		
func play_click() -> void:
	click_sound.play()
		
func swing_cursor() -> void:
	tween = create_tween()
	await tween.tween_property(cursor, "position:x", cursor.position.x - 20, 0.4).finished
	tween.kill()
	tween = create_tween()
	await tween.tween_property(cursor, "position:x", cursor.position.x + 20, 0.4).finished
	swing_cursor()

func move_cursor_to_button() -> void:
	if focus:
		move_sound.play()
		global_position.x = focus.global_position.x - cursor_offset
		global_position.y = focus.global_position.y

func set_focus(new_gui_focus: Control) -> void:
	focus = new_gui_focus
