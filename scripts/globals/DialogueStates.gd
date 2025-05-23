extends Node

func set_npc_met(npc_name: String) -> void:
    if not SaveManager.save_dict["npcs"].has(npc_name):
        SaveManager.save_dict["npcs"].append(npc_name)
    SaveManager.save_game()
