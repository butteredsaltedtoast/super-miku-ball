extends ProgressBar

func _process(delta: float) -> void:
	if GameState.player == null:
		return
	value = GameState.player.health / GameState.player.maxHealth
