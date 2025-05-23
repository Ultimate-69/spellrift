class_name DialogueComponent extends Node2D

@export var prompt_offset: Vector2
@export var prompt_radius: float = 64
@export var prompt_visible: bool = true

@onready var prompt: Sprite2D = $DialgouePrompt
@onready var dialogue_area: Area2D = $DialogueArea
@onready var dialogue_area_shape: CollisionShape2D = $DialogueArea/CollisionShape2D

func _ready():
	prompt.position = prompt_offset
	dialogue_area_shape.shape.radius = prompt_radius

	dialogue_area.body_entered.connect(func(body):
		if body is Player:
			if prompt_visible:
				prompt.visible = true
		)

	dialogue_area.body_exited.connect(func(body):
		if body is Player:
			if prompt_visible:
				prompt.visible = false
		)
