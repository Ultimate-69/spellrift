class_name InventoryItem extends Node2D

@export_category("Item Details")
@export var item_name: String
@export var item_value: float
@export var item_image: Texture

var items: Dictionary[String, InventoryItem] = {
    "fire_rune" = InventoryItem.new("Fire Rune", 50, null)
}

func get_item_from_name(item_name_param: String) -> InventoryItem:
    return items[item_name_param]
    
func _init(name: String, value: float, image: Texture) -> void:
    item_name = name
    item_value = value
    item_image = image
