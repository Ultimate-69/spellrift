class_name Spells extends Node

# [ELEMENT | TYPE | MODIFIER] | SCENE PATH | KEY
static var spells: Dictionary[String, Array] = {
	"none" = [["None", "None", "None"], null, "none"],
	"fire_ball" = [["Fire", "Missle", "None"], "res://scenes/spells/fireball.tscn", "fire_ball"],
}
