extends Node

# waits for the seconds provided
func wait(time: float) -> void:
	await get_tree().create_timer(time).timeout
