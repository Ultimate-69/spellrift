class_name FireRing extends BaseSpell

@onready var hitbox_component: HitboxComponent = $HitboxComponent

@onready var spell_audio_player: AudioStreamPlayer2D = $SpellAudioPlayer
@onready var spell_hit_audio_player: AudioStreamPlayer2D = $SpellHitAudioPlayer

func _ready() -> void:
	hitbox_component.area_entered.connect(func(area):
		if area is HurtboxComponent and not area.get_parent() is Player:
			area.take_damage(Attack.new(spell_base_damage, Vector2.ZERO))
			spell_hit_audio_player.play()
			hitbox_component.queue_free()
			$AnimatedSprite2D.play("explode")
			await spell_hit_audio_player.finished
			queue_free()
	)
	spell_audio_player.play()
	

func cast(target: Vector2) -> void:
	var clone_count: int = 6
	var radius: float = 100.0  # Distance from the player
	for i in range(clone_count):
		var angle: float = (TAU / clone_count) * i  # TAU is 2 * PI
		var offset: Vector2 = Vector2(cos(angle), sin(angle)) * radius
		var clone: FireRing = duplicate()
		get_parent().add_child(clone)
		clone.global_position = clone.global_position + offset
