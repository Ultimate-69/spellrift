class_name Attack extends Node

var damage: int
var knockback_force: int

func _init(attack_damage: int, attack_knockback_force: int) -> void:
	self.damage = attack_damage
	self.knockback_force = attack_knockback_force
