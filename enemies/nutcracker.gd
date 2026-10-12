extends Enemy
@export var projectile_scene : PackedScene
func _on_shoot_timer_timeout() -> void:
	if GameState.player == null or GameState.player.dead or GameState.inMenu:
		return
	GameState.play_sfx("res://Audio/SFX/snd_bullet_warning_1.mp3", -15)
	$WarnTimer.start()

func _on_warn_timer_timeout() -> void:
	if GameState.player == null or GameState.player.dead or GameState.inMenu:
		return
	var p = projectile_scene.instantiate()
	p.global_position = global_position
	p.direction = global_position.direction_to(GameState.player.global_position)
	GameState.play_sfx("res://Audio/SFX/snd_shot_1.mp3", -12)
	get_tree().current_scene.add_child(p)
