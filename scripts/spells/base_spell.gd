class_name BaseSpell extends CharacterBody2D

@export_category("Spell Details")
@export var spell_element: Enums.elements
@export var spell_type: Enums.types
@export var spell_modifier: Enums.modifiers
@export_category("Spell Stats")
@export var spell_base_damage: float
@export var spell_base_speed: float
@export var spell_cooldown: float
@export_category("Spell Effects")
@export var spell_dps: float
@export var spell_duration: float

@warning_ignore("unused_parameter")
func cast(target: Vector2) -> void:
    pass
