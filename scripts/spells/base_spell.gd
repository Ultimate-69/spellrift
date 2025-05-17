class_name BaseSpell extends CharacterBody2D

enum elements {
	None,
	Fire,
}

enum types {
	None,
	Missle,
}

enum modifiers {
	None,
	Homing
}

@export_category("Spell Details")
@export var spell_element: elements
@export var spell_type: types
@export var spell_modifier: modifiers
@export_category("Spell Stats")
@export var spell_base_damage: float
@export var spell_base_speed: float
