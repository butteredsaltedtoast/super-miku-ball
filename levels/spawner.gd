extends Node2D
@export var enemy_scenes : Array[PackedScene]
var enemySpread = [0,0.2,0.4,0.6]
func _on_timer_timeout() -> void:
	if (GameState.inMenu):
		return
	if GameState.player == null or GameState.player.dead:
		return
	var enemy = 0
	if (randf() < enemySpread[min(GameState.level,len(enemySpread)-1)]):
		enemy = 1
	var e = enemy_scenes[enemy].instantiate()
	e.global_position = GameState.player.global_position + Vector2.RIGHT.rotated(randf() * TAU) * 700
	get_tree().current_scene.add_child(e)
