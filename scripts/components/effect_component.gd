class_name EffectComponent extends Node2D

@export var hurtbox_component: HurtboxComponent

func apply_effect(damage_per_second: float, duration_seconds: float) -> void:
    var waited: float = 0
    hurtbox_component.take_damage(Attack.new(damage_per_second, Vector2.ZERO))
    while waited < duration_seconds:
        await Globals.wait(1.0)
        waited += 1
        hurtbox_component.take_damage(Attack.new(damage_per_second, Vector2.ZERO))
