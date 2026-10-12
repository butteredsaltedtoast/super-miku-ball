extends Area2D
var direction : Vector2
var speed : float = 300.0

func _physics_process(delta: float) -> void:
	if GameState.inMenu: return
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body == GameState.player:
		GameState.player.take_damage(1.0)
		queue_free()

func _ready() -> void:
	$AnimatedSprite2D.play()

func _on_timer_timeout() -> void:
	queue_free()
