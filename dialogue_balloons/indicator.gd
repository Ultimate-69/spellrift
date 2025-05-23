extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    rotate_indicator()


func rotate_indicator() -> void:
    var tween = create_tween()
    await tween.tween_property(self, "position", Vector2(1094, 82), 0.4).from(Vector2(1094, 75)).finished
    tween = create_tween()
    await tween.tween_property(self, "position", Vector2(1094, 75), 0.4).from(Vector2(1094, 82)).finished
    rotate_indicator()
