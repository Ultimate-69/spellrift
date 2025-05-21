class_name Fireball extends BaseSpell

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var spell_hit_audio_player: AudioStreamPlayer2D = $SpellHitAudioPlayer
@onready var spell_audio_player: AudioStreamPlayer2D = $SpellAudioPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var tween: Tween

func _ready() -> void:
	hitbox_component.area_entered.connect(body_entered)

	hitbox_component.body_entered.connect(func(body: Node2D):
		if body is Player:
			return

		velocity = Vector2(0, 0)
		animated_sprite_2d.play("explode")
		spell_hit_audio_player.play()
		await animated_sprite_2d.animation_finished
		queue_free()
	)

	spell_audio_player.play()
	
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func body_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		if area.get_parent() is not Player:
			var direction_to_opponent = global_position.direction_to(area.get_parent().global_position)
			@warning_ignore("narrowing_conversion")
			area.take_damage(Attack.new(self.spell_base_damage, direction_to_opponent * 20))
			
			# fire effect, continous damage
			var dps: float = spell_dps
			area.effect_component.apply_effect(dps, spell_duration)
			
			velocity = Vector2(0, 0)
			animated_sprite_2d.play("explode")
			spell_hit_audio_player.play()
			await animated_sprite_2d.animation_finished
			queue_free()

func cast(target: Vector2) -> void:
	animated_sprite_2d.play("shot")
	look_at(target)
	velocity = global_position.direction_to(target) * (spell_base_speed * 10)
	await Globals.wait(2)
	velocity = Vector2(0, 0)
	spell_hit_audio_player.play()
	animated_sprite_2d.play("explode")
	await animated_sprite_2d.animation_finished
	queue_free()
