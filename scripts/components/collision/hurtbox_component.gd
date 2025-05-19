class_name HurtboxComponent extends Area2D

@export var health_component: HealthComponent
@export var effect_component: EffectComponent
@export var knockback_body: CharacterBody2D

func take_damage(attack: Attack) -> void:
	health_component.take_damage(attack)
	if knockback_body:
		if knockback_body is Player:
			knockback_body.is_knockback = true
		knockback_body.velocity = attack.knockback_force * 10
		await Globals.wait(0.1)
		if knockback_body is Player:
			knockback_body.is_knockback = false
		knockback_body.velocity = Vector2(0, 0)
