extends Node

const SAVE_PATH = "user://save.spell"
const PASSWORD = "9fa!DN49D+rBS^Hdap2^Ce&!WD^uxaRSj3f#UfdFHdgQ7EgY)g)d4YbTamB$J#TY"

var loaded: bool = false

var save_dict: Dictionary = {
    # Global Data
    "runs" = 0,
    "kills" = 0,
    "gold" = 0, # meta-currency
    "characters" = [],
    "spells_discovered" = [],
    "runes_found" = [],
    "saved_rune" = "none",
    # Per-Run Data
    "is_in_run" = false,
    "shards" = 0, # per-run currency
    "current_floor" = 1,
    "current_spells" = [Spells.spells["none"]], 
    # each array entry above is a spell
    "current_character" = "apprentice", # default character
    "inventory" = [],
    "upgrades" = [],
    "npcs" = [],
}

func save_game() -> void:
    var file = FileAccess.open_encrypted_with_pass(SAVE_PATH,
     FileAccess.WRITE, PASSWORD)
    
    file.store_string(JSON.stringify(save_dict))
    file.close()

# returns 1 if no save, 2 if failed to load, else returns data dictionary.
func load_game():
    var file = FileAccess.open_encrypted_with_pass(SAVE_PATH,
     FileAccess.READ, PASSWORD)
    
    if file == null:
        loaded = true
        if FileAccess.get_open_error() == ERR_FILE_NOT_FOUND:
            # no file found
            return 1
        else:
            # other error that stopped from opening file
            return 2
    else:
        var data: Dictionary = JSON.parse_string(file.get_as_text())
        file.close()
        save_dict = data
        loaded = true
        return data
