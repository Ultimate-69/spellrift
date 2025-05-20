class_name Spells extends Node

# [ELEMENT | TYPE | MODIFIER] | SCENE PATH | KEY
static var spells: Dictionary[String, Array] = {
	# some of these have the same scene just modified with modifiers,
	# so just because it has a modifier of "None" doesn't mean it doesn't have
	# a modifier
	"none" = [["None", "None", "None"], null, "none"],
	"fire_ball" = [["Fire", "Missle", "None"], "res://scenes/spells/fireball.tscn", "fire_ball"],
	"fire_ring" = [["Fire", "Orbital", "None"], "res://scenes/spells/fire_ring.tscn", "fire_ring"],
}
