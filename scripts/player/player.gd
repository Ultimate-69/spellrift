class_name Player extends CharacterBody2D

const SPEED: float = 400.0
const SMOOTH_FACTOR: float = 100.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var footstep_component: FootstepComponent = $FootstepComponent
@onready var controls: Control = $PlayerUI/UIContainer/Controls
@onready var cursor: TextureRect = $PlayerUI/UIContainer/Spells/Selected
@onready var spell_1: Control = $PlayerUI/UIContainer/Spells/Spell1
@onready var spell_2: Control = $PlayerUI/UIContainer/Spells/Spell2
@onready var spell_3: Control = $PlayerUI/UIContainer/Spells/Spell3

var tween: Tween

var selected_spell: Array = Spells.spells["none"]
var is_knockback: bool = false
var cursor_pos: int = 1
var cursor_offset = Vector2(10, -20)

var spells: Dictionary = {
	"1" = {
		"name" = "fire_ball",
		"cooldown" = false,
		"cooldown_time_passed" = 0
	},
	"2" = {
		"name" = "fire_ring",
		"cooldown" = false,
		"cooldown_time_passed" = 0
	},
	"3" = {
		"name" = "none",
		"cooldown" = false,
		"cooldown_time_passed" = 0
	},
}

# ui
@onready var health_bar: ProgressBar = $PlayerUI/UIContainer/Health/HealthBar

func _ready() -> void:
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.health
	health_component.damaged.connect(health_changed)
	
	$PlayerUI/UIContainer/Spells/Spell1/Name.text = "Fireball"
	$PlayerUI/UIContainer/Spells/Spell1/SpellIconHolder/Icon.texture = preload("res://assets/sprites/vfx/fire/fireball.png")
	$PlayerUI/UIContainer/Spells/Spell2/Name.text = "Fire Ring"
	$PlayerUI/UIContainer/Spells/Spell2/SpellIconHolder/Icon.texture = preload("res://assets/sprites/vfx/fire/firecircle.png")
	swing_cursor()
	
func _process(_delta: float) -> void:
	# prepare spell, B
	if Input.is_action_just_pressed("spell_select"):
		if selected_spell != Spells.spells["none"]:
			Globals.change_mouse_icon(null)
			selected_spell = Spells.spells["none"]
			$PlayerUI/UIContainer/Controls/HBoxContainer/Cast.visible = false
			$PlayerUI/UIContainer/Controls/HBoxContainer/Prepare/PrepareLabel.text = "Prepare Spell"
		else:
			selected_spell = Spells.spells[spells[str(cursor_pos)]["name"]]
			Globals.change_mouse_icon(Globals.mouse_icons["mouse_circle_x_icon"])
			$PlayerUI/UIContainer/Controls/HBoxContainer/Prepare/PrepareLabel.text = "Cancel Spell"
			$PlayerUI/UIContainer/Controls/HBoxContainer/Cast.visible = true
	
	# E
	if Input.is_action_just_pressed("choose_spell"):
		if cursor_pos == 1 and spell_2.visible:
			cursor_pos = 2
			cursor.position = spell_2.position - cursor_offset
		elif cursor_pos == 2:
			if spell_3.visible:
				cursor_pos = 3
				cursor.position = spell_3.position - cursor_offset
			else:
				cursor_pos = 1
				cursor.position = spell_1.position - cursor_offset
		elif cursor_pos == 3:
			cursor_pos = 1
			cursor.position = spell_1.position - cursor_offset
			
		selected_spell = Spells.spells[spells[str(cursor_pos)]["name"]]
		print(selected_spell)

	if Input.is_action_just_pressed("cast"):
		if selected_spell == Spells.spells["none"]: return
		
		var choice: int = cursor_pos
		
		if spells[str(choice)]["cooldown"]: return
		
		var spell_scene: PackedScene = load(Spells.spells[selected_spell[2]][1])
		var instanced_spell: BaseSpell = spell_scene.instantiate()
		if get_global_mouse_position().x < global_position.x:
			animated_sprite_2d.flip_h = true
		elif get_global_mouse_position().x > global_position.x:
			animated_sprite_2d.flip_h = false
		if selected_spell[0][1] == "Orbital":
			animated_sprite_2d.play("staff_cast")
		else:
			animated_sprite_2d.play("cast")
		
		if selected_spell[0][1] == "Orbital":
			add_child(instanced_spell)
		else:
			get_parent().add_child(instanced_spell)
			
		instanced_spell.global_position = global_position
		instanced_spell.cast(get_global_mouse_position())
		
		spell_cooldown(choice, instanced_spell.spell_cooldown)
		
	if Input.is_action_just_pressed("hide_controls"):
		controls.visible = not controls.visible

func _physics_process(_delta: float) -> void:
	if is_knockback:
		move_and_slide()
		return
		
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		if not footstep_component.is_footstep_playing():
			footstep_component.play_footstep()
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
	
func swing_cursor() -> void:
	var new_tween = create_tween()
	await new_tween.tween_property(cursor, "position:x", cursor.position.x - 20, 0.4).finished
	new_tween.kill()
	new_tween = create_tween()
	await new_tween.tween_property(cursor, "position:x", cursor.position.x + 20, 0.4).finished
	swing_cursor()
	
func spell_cooldown(spell_index: int, cooldown_time: float) -> void:
	spells[str(spell_index)]["cooldown"] = true
	var path: String = "PlayerUI/UIContainer/Spells/Spell" + str(spell_index) + "/SpellIconHolder/Icon/Cooldown"
	var node: Label = get_node(path)
	node.text = str(cooldown_time) + "s"
	
	var icon_path: String = "PlayerUI/UIContainer/Spells/Spell" + str(spell_index) + "/SpellIconHolder/Icon"
	var icon: TextureRect = get_node(icon_path)
	
	icon.modulate = Color(1, 1, 1, 0.5)
	
	while spells[str(spell_index)]["cooldown_time_passed"] < cooldown_time:
		await Globals.wait(0.1)
		spells[str(spell_index)]["cooldown_time_passed"] += 0.1
		node.text = str(abs(Globals.round_place(cooldown_time - spells[str(spell_index)]["cooldown_time_passed"], 2))) + "s"
	
	icon.modulate = Color(1, 1, 1, 1)
	
	spells[str(spell_index)]["cooldown"] = false
	spells[str(spell_index)]["cooldown_time_passed"] = 0
	node.text = "0s"


	
