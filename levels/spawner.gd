extends Node2D
@export var enemy_scenes : Array[PackedScene]

func _on_timer_timeout() -> void:
	if GameState.player == null or GameState.player.dead:
		return
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = GameState.player.global_position + Vector2.RIGHT.rotated(randf() * TAU) * 700
	get_tree().current_scene.add_child(e)
