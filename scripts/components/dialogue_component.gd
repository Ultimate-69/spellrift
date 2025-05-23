class_name DialogueComponent extends Node2D

@export var prompt_offset: Vector2
@export var prompt_radius: float = 64
@export var prompt_visible: bool = true

@onready var prompt: Sprite2D = $DialgouePrompt
@onready var dialogue_area: Area2D = $DialogueArea
@onready var dialogue_area_shape: CollisionShape2D = $DialogueArea/CollisionShape2D

var default_scale: Vector2
var tween: Tween

signal dialogue_started

func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action("interact"):
        dialogue_started.emit()

func _ready() -> void:
    default_scale = prompt.scale
    prompt.position = prompt_offset
    dialogue_area_shape.shape.radius = prompt_radius

    dialogue_area.body_entered.connect(func(body):
        if body is Player:
            if prompt_visible:
                show_prompt()
        )

    dialogue_area.body_exited.connect(func(body):
        if body is Player:
            if prompt_visible:
                hide_prompt()
        )

func show_prompt() -> void:
    prompt.visible = true
    tween = create_tween()
    tween.tween_property(prompt, "scale", default_scale, 0.3).from(Vector2(0, 0)).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func hide_prompt() -> void:
    tween = create_tween()
    await tween.tween_property(prompt, "scale", Vector2(0, 0), 0.3).from(prompt.scale).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).finished
    prompt.visible = false
