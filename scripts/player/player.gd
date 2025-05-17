class_name Player extends CharacterBody2D

const SPEED: float = 500.0
const SMOOTH_FACTOR: float = 100.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var area: Area2D

func _ready() -> void:
	area = $Area2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var areas = area.get_overlapping_areas()
		for i in areas:
			if i is HurtboxComponent and not i.get_parent() == self:
				var direction_to_opponent = global_position.direction_to(i.get_parent().position)
				i.take_damage(Attack.new(10, direction_to_opponent * 10))

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		animated_sprite_2d.play("move")
		
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
		elif direction.x > 0:
			animated_sprite_2d.flip_h = false
		
		velocity = direction * SPEED
	else:
		animated_sprite_2d.play("idle")
		velocity.x = move_toward(velocity.x, 0, SMOOTH_FACTOR - SPEED / 10)
		velocity.y = move_toward(velocity.y, 0, SMOOTH_FACTOR - SPEED / 10)

	move_and_slide()
