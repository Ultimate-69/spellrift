extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent

func _ready() -> void:
	attack()
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	
func attack() -> void:
	$AnimatedSprite2D.play("attack")
	var result = hitbox_component.attack()
	if result:
		for area in result:
			if area is HurtboxComponent:
				if area.get_parent() != self:
					var direction_to_opponent = global_position.direction_to(area.get_parent().global_position)
					area.take_damage(Attack.new(5, direction_to_opponent * 50))
	await Globals.wait(0.7)
	attack()
