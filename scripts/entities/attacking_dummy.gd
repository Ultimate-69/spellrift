extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
    health_component.on_entity_death.connect(revive)
    attack()
    
func _physics_process(_delta: float) -> void:
    move_and_slide()
    
func attack() -> void:
    animated_sprite_2d.play("attack")
    var result = hitbox_component.attack()
    if result:
        for area in result:
            if area is HurtboxComponent:
                if area.get_parent() != self:
                    var direction_to_opponent = global_position.direction_to(area.get_parent().global_position)
                    area.take_damage(Attack.new(5, direction_to_opponent * 50))
    await Globals.wait(0.7)
    attack()
    
func revive() -> void:
    health_component.regen_health(health_component.max_health)
