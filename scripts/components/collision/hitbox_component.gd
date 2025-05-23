class_name HitboxComponent extends Area2D

func attack():
    var components = []
    var areas = get_overlapping_areas()
    for area in areas:
        if area is HurtboxComponent:
            components.append(area)
    if components.size() > 0:
        return components
    else:
        return null
