extends Node

const VERSION_NUM: String = "v0.0.1 DEV"

# waits for the seconds provided
func wait(time: float) -> void:
	await get_tree().create_timer(time).timeout
