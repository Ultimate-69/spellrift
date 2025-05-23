extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent

func _physics_process(_delta: float) -> void:
    move_and_slide()

func _ready() -> void:
    health_component.on_entity_death.connect(dummy_died)
    health_component.damaged.connect(dummy_hit)
    
func dummy_died() -> void:
    health_component.regen_health(health_component.max_health)
    
func dummy_hit() -> void:
    $AnimatedSprite2D.play("hit_normal")
