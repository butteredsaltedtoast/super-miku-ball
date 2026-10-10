extends CharacterBody2D

const SPEED : float = 100.0
var hp : float = 100.0

func _physics_process(delta: float) -> void:
	if GameState.player == null: return
	velocity = global_position.direction_to(GameState.player.global_position) * SPEED
	move_and_slide()

func take_damage(damage: float) -> void:
	hp -= damage
	if(hp <= 0):
		queue_free()
