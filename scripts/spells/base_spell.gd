class_name BaseSpell extends CharacterBody2D

enum elements {
	None,
	Fire,
	Ice,
	Lightning,
	Poison,
	Arcane,
	Void
}

enum types {
	None,
	Missle,
	Beam,
	Orbital,
	Trap
}

enum modifiers {
	None,
	Homing,
	Pierce,
	Split,
	Delay,
}

@export_category("Spell Details")
@export var spell_element: elements
@export var spell_type: types
@export var spell_modifier: modifiers
@export var spell_sfx: AudioStream
@export_category("Spell Stats")
@export var spell_base_damage: float
@export var spell_base_speed: float

func cast(target: Vector2) -> void:
	pass
