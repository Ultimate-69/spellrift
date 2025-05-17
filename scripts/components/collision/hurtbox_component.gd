class_name HurtboxComponent extends Area2D

@export var health_component: HealthComponent
@export var knockback_body: Node2D

func take_damage(attack: Attack) -> void:
	health_component.take_damage(attack)
	if knockback_body:
		var tween = create_tween()
		tween.tween_property(knockback_body, "position", 
			knockback_body.position + attack.knockback_force, 0.1)
