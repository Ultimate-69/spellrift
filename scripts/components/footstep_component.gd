class_name FootstepComponent extends AudioStreamPlayer

func play_footstep() -> void:
    pitch_scale = randf_range(0.9, 1.1)
    play()
    
func is_footstep_playing() -> bool:
    return playing
