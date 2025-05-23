class_name FireRing extends BaseSpell

@onready var hitbox_component: HitboxComponent = $HitboxComponent

@onready var spell_audio_player: AudioStreamPlayer2D = $SpellAudioPlayer
@onready var spell_hit_audio_player: AudioStreamPlayer2D = $SpellHitAudioPlayer

var orbit_radius: float = 100.0
var orbit_angle: float = 0.0
var orbit_speed: float = 1.5  # radians per second

var should_orbit: bool = true

func init_orbit(radius: float, angle: float) -> void:
	orbit_radius = radius
	orbit_angle = angle
	position = Vector2(cos(orbit_angle), sin(orbit_angle)) * orbit_radius 

func _ready() -> void:
	hitbox_component.area_entered.connect(func(area):
		if area is HurtboxComponent and not area.get_parent() is Player:
			area.take_damage(Attack.new(spell_base_damage, Vector2.ZERO))
			spell_hit_audio_player.play()
			hitbox_component.queue_free()
			$AnimatedSprite2D.play("explode")
			should_orbit = false
			if self.get_parent() is Player:
				call_deferred("defer_reparent")
			await spell_hit_audio_player.finished
			queue_free()
	)
	spell_audio_player.play()
	
func defer_reparent() -> void:
	self.reparent(get_parent().get_parent())
	
func _process(delta: float) -> void:
	if not should_orbit: return
	orbit_angle += orbit_speed * delta
	position = Vector2(cos(orbit_angle), sin(orbit_angle)) * orbit_radius
	

func cast(target: Vector2) -> void:
	var clone_count: int = 6
	var radius: float = 100.0  # Distance from the player
	for i in range(clone_count):
		var angle: float = (TAU / clone_count) * i
		var offset: Vector2 = Vector2(cos(angle), sin(angle)) * radius
		var clone: FireRing = duplicate()
		get_parent().add_child(clone)
		clone.init_orbit(radius, angle)
		clone.global_position = clone.global_position + offset
	queue_free()
