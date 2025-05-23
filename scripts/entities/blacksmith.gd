class_name Blacksmith extends NPC

@onready var dialogue_component: DialogueComponent = $DialogueComponent

func _ready() -> void:
    dialogue_component.dialogue_started.connect(dialogue_started)

func dialogue_started() -> void:
    DialogueManager.show_dialogue_balloon(dialogue_resource, "start")
