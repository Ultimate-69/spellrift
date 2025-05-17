extends Control

const START_POS = Vector2(1160, 484)
const END_POS = Vector2(691, 484)

@onready var panel: Panel = $Panel
@onready var title: Label = $Panel/Title
@onready var body: Label = $Panel/Body
@onready var notification_sound: AudioStreamPlayer = $NotificationSound

var tween: Tween

func send_notification(body_text: String, title_text: String) -> void:
	notification_sound.play()
	panel.position = START_POS
	
	tween = create_tween()
	tween.tween_property(panel, "position", END_POS, 0.3)
	
	panel.visible = true
	title.text = title_text
	body.text = body_text
	
	await Globals.wait(4)
	
	tween = create_tween()
	await tween.tween_property(panel, "position", START_POS, 0.3).finished
	
	panel.visible = false
