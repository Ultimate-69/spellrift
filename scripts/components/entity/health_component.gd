class_name HealthComponent extends Node2D

@export var entity_sprite: Node2D # animated or normal
@export_category("Options")
@export_range(1, 500) var max_health: int = 100
@export var hit_flash: bool = true
@export var show_health: bool = false

@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var health_bar: ProgressBar = $HealthBar

var health: int
var tween: Tween

signal on_entity_death

func _ready() -> void:
	health = max_health
	if show_health:
		health_bar.max_value = max_health
		health_bar.value = max_health
		health_bar.visible = true
		health_bar.reparent(entity_sprite, false)
		health_bar.position = entity_sprite.position + Vector2(-20, -25)
	else:
		health_bar.visible = false

func take_damage(attack: Attack) -> void:
	health -= attack.damage
	if show_health:
		tween = create_tween()
		tween.tween_property(health_bar, "value", health, 0.5)
	hit_sound.play()
	if hit_flash:
		entity_sprite.modulate = Color(1.5, 0, 0)
		
		await Globals.wait(0.1)
		
		entity_sprite.modulate = Color(2, 2, 2)
		
		tween = create_tween()
		tween.tween_property(entity_sprite, "scale", scale + Vector2(0.1, 0.1), 0.1).set_trans(tween.TRANS_SPRING)
		
		await Globals.wait(0.1)
		
		entity_sprite.modulate = Color(1, 1, 1)
		
		tween = create_tween()
		tween.tween_property(entity_sprite, "scale", scale - Vector2(0.1, 0.1), 0.1).set_ease(Tween.EASE_IN_OUT)
	if health <= 0:
		# dead
		on_entity_death.emit()
		
func regen_health(regen: int) -> void:
	if show_health:
		tween = create_tween()
		tween.tween_property(health_bar, "value", health, 0.5)
	health += regen
