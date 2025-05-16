extends Node

var todos: Array[String] = [

]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.is_debug_build():
		if todos.size() > 0:
			print("--- TO-DO ---")
			for i in todos.size():
				print(str(i + 1) + ". " + todos[i])
