extends Node

signal npc_action_activated(npc_name: String)

func activate_npc_action(npc_name: String) -> void:
    npc_action_activated.emit(npc_name)
