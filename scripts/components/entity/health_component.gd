class_name HealthComponent extends Node2D

@export var entity_sprite: Node2D # animated or normal
@export_category("Options")
@export_range(1, 500) var health: int = 100
@export var hit_flash: bool = true

@onready var hit_sound: AudioStreamPlayer = $HitSound

var tween: Tween

signal on_entity_death

func take_damage(attack: Attack) -> void:
	health -= attack.damage
	hit_sound.play()
	if hit_flash:
		entity_sprite.modulate = Color(1.5, 0, 0)
		
		await Globals.wait(0.1)
		
		entity_sprite.modulate = Color(2, 2, 2)
		
		tween = create_tween()
		tween.tween_property(entity_sprite, "scale", Vector2(1.1, 1.1), 0.1).set_trans(tween.TRANS_SPRING)
		
		await Globals.wait(0.1)
		
		entity_sprite.modulate = Color(1, 1, 1)
		
		tween = create_tween()
		tween.tween_property(entity_sprite, "scale", Vector2(1.0, 1.0), 0.1).set_ease(Tween.EASE_IN_OUT)
	if health <= 0:
		# dead
		on_entity_death.emit()
		
func regen_health(regen: int) -> void:
	health += regen
