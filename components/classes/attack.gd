class_name Attack extends Node

var damage: int
var knockback_force: Vector2

func _init(attack_damage: int, attack_knockback_force: Vector2) -> void:
	self.damage = attack_damage
	self.knockback_force = attack_knockback_force
