extends Area2D
var direction : Vector2
var speed : float = 300.0
var deflected = false

func _physics_process(delta: float) -> void:
	if GameState.inMenu: return
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if deflected:
		if body.is_in_group("enemies"):
			body.take_damage(50.0, self)
			queue_free()
	elif body == GameState.player:
		GameState.player.take_damage(1.0)
		queue_free()

func _ready() -> void:
	$AnimatedSprite2D.play()

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if deflected or GameState.player == null or GameState.player.parry_time <= 0:
		return
	if area == GameState.player.yoyo or area == GameState.player.ropeCollide:
		deflected = true
		direction = -direction
		speed *= 1.5
		GameState.play_sfx("res://Audio/SFX/snd_bullet_parry.mp3")
