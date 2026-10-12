extends Enemy
@export var projectile_scene : PackedScene
func _on_shoot_timer_timeout() -> void:
	if GameState.inMenu:
		return
	if GameState.player == null or GameState.player.dead:
		return
	var p = projectile_scene.instantiate()
	p.global_position = global_position
	p.direction = global_position.direction_to(GameState.player.global_position)
	get_tree().current_scene.add_child(p)
