extends Control

const TEXT_SPEED: float = 1

var tween: Tween
var is_speaking: bool = false
var last_visible_chars: int = 0

@onready var dialogue_panel: Panel = $DialoguePanel
@onready var speaker: Label = $DialoguePanel/Speaker
@onready var icon: TextureRect = $DialoguePanel/Icon
@onready var dialogue: RichTextLabel = $DialoguePanel/Dialogue
@onready var dialogue_sound: AudioStreamPlayer = $DialogueSound

func _ready() -> void:
    dialogue_panel.visible = false

func _process(delta: float) -> void:
    if is_speaking:
        var current_chars: int = dialogue.visible_characters
        if current_chars > last_visible_chars:
            dialogue_sound.play()
            last_visible_chars = current_chars

func say(text: String, speaker_name: String, speaker_icon, speaker_sound) -> void:
    if not dialogue_panel.visible:
        dialogue_panel.visible = true
        dialogue_panel.modulate = Color(1, 1, 1, 0)
        tween = create_tween()
        await tween.tween_property(dialogue_panel, "modulate", Color(1, 1, 1, 1), 0.3).finished
        await Globals.wait(0.3)

    is_speaking = true
    last_visible_chars = 0

    speaker.text = speaker_name
    dialogue.text = text
    icon.texture = speaker_icon

    if speaker_sound != null:
        dialogue_sound.stream = speaker_sound
    else:
        dialogue_sound.stream = preload("res://assets/sfx/click1.wav")

    dialogue.visible_ratio = 0
    tween = create_tween()
    await tween.tween_property(dialogue, "visible_ratio", 1, TEXT_SPEED).finished

    is_speaking = false
    
func hide_dialoge() -> void:
    dialogue_panel.visible = false
