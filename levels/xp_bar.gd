extends TextureProgressBar

func _process(delta: float) -> void:
	max_value = GameState.xp_to_level
	value = GameState.xp
