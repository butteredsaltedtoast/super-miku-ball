extends Node2D
@export var enemy_scenes : Array[PackedScene]
var enemySpread = [0,0.2,0.4,0.6]

func _ready() -> void:
	GameState.updateLevel.connect(_on_level_up)

func _on_timer_timeout() -> void:
	if (GameState.inMenu):
		return
	if GameState.player == null or GameState.player.dead:
		return
	if get_tree().get_nodes_in_group("enemies").size() >= 60:
		return
	var enemy = 0
	if (randf() < enemySpread[min(GameState.level,len(enemySpread)-1)]):
		enemy = 1
	var e = enemy_scenes[enemy].instantiate()
	e.global_position = GameState.player.global_position + Vector2.RIGHT.rotated(randf() * TAU) * 700
	e.hp = e.maxHP * (1 + GameState.run_time / 600.0)
	get_tree().current_scene.add_child(e)

func _on_level_up(level: int) -> void:
	$Timer.wait_time = max(0.4, 3 * pow(0.85, level - 1))
