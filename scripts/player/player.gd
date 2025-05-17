class_name Player extends CharacterBody2D

const SPEED: float = 500.0
const SMOOTH_FACTOR: float = 100.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent

var tween: Tween

var selected_spell: Array = ["None", "None", "None"]

# ui
@onready var health_bar: ProgressBar = $PlayerUI/UIContainer/Health/HealthBar

func _ready() -> void:
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.health
	health_component.damaged.connect(health_changed)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("spell_1"):
		if selected_spell != Spells.spells["none"]:
			Globals.change_mouse_icon(null)
			selected_spell = Spells.spells["none"]
		else:
			selected_spell = Spells.spells["fire_ball"]
			Globals.change_mouse_icon(Globals.mouse_icons["mouse_circle_x_icon"])
			
	if Input.is_action_just_pressed("cast"):
		if selected_spell == Spells.spells["none"]: return
		var spell_scene: PackedScene = load(Spells.spells["fire_ball"][1])
		var instanced_spell: BaseSpell = spell_scene.instantiate()
		if get_global_mouse_position().x < global_position.x:
			animated_sprite_2d.flip_h = true
		elif get_global_mouse_position().x > global_position.x:
			animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("cast")
		
		get_parent().add_child(instanced_spell)
		instanced_spell.global_position = global_position
		instanced_spell.cast(get_global_mouse_position())

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		if animated_sprite_2d.animation == "idle" or animated_sprite_2d.animation == "move":
			animated_sprite_2d.play("move")
		else:
			if not animated_sprite_2d.is_playing():
				animated_sprite_2d.play("move")
		
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
		elif direction.x > 0:
			animated_sprite_2d.flip_h = false
		
		velocity = direction * SPEED
	else:
		if animated_sprite_2d.animation == "idle" or animated_sprite_2d.animation == "move":
			animated_sprite_2d.play("idle")
		else:
			if not animated_sprite_2d.is_playing():
				animated_sprite_2d.play("idle")
		velocity.x = move_toward(velocity.x, 0, SMOOTH_FACTOR - SPEED / 10)
		velocity.y = move_toward(velocity.y, 0, SMOOTH_FACTOR - SPEED / 10)

	move_and_slide()

func health_changed() -> void:
	tween = create_tween()
	tween.tween_property(health_bar, "value", health_component.health, 0.2)
