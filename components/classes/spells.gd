class_name Spells extends Node

# ELEMENT | TYPE | MODIFIER
static var spells: Dictionary[String, Array] = {
	"none" = [["None", "None", "None"], null],
	"fire_ball" = [["Fire", "Missle", "None"], "res://scenes/spells/fireball.tscn"],
}
