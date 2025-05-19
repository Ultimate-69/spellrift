extends Node

const VERSION_NUM: String = "v0.0.4 DEV"

var mouse_icons: Dictionary[String, Texture2D] = { 
	"mouse_circle_x_icon" = load("res://assets/images/crosshairs/crosshair052.png"),
	"empty" = load("res://assets/images/crosshairs/crosshair001.png"),
	"plus" = load("res://assets/images/crosshairs/crosshair002.png"),
	"cross" = load("res://assets/images/crosshairs/crosshair005.png"),
	"two_arrows" = load("res://assets/images/crosshairs/crosshair018.png"),
	"square" = load("res://assets/images/crosshairs/crosshair032.png"),
	"eye" = load("res://assets/images/crosshairs/crosshair140.png"),
	"cancel" = load("res://assets/images/crosshairs/crosshair113.png"),
	"triangle" = load("res://assets/images/crosshairs/crosshair100.png"),
	"eye_arrows" = load("res://assets/images/crosshairs/crosshair058.png")
}

func change_mouse_icon(mouse_icon) -> void:
	Input.set_custom_mouse_cursor(mouse_icon)

# waits for the seconds provided
func wait(time: float) -> void:
	await get_tree().create_timer(time).timeout
	
func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
