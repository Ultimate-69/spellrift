extends Node

const VERSION_NUM: String = "v0.0.1 DEV"

var mouse_icons = { 
	"mouse_circle_x_icon" = load("res://assets/images/crosshairs/crosshair052.png"),
}

func change_mouse_icon(mouse_icon) -> void:
	Input.set_custom_mouse_cursor(mouse_icon)

# waits for the seconds provided
func wait(time: float) -> void:
	await get_tree().create_timer(time).timeout
