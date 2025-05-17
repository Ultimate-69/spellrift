class_name HurtboxComponent extends Area2D

@export var health_component: HealthComponent

func take_damage(attack: Attack) -> void:
	health_component.take_damage(attack)
