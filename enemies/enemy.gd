extends CharacterBody2D

const SPEED : float = 100.0
@export var maxHP : float = 100.0
var hp : float = maxHP
var dmgCooldown : float = 0.3
var cooldownTime : float = dmgCooldown
func _physics_process(delta: float) -> void:
	if GameState.player == null: return
	velocity = (global_position.direction_to(GameState.player.global_position) * SPEED * delta)+ velocity * (1 - delta)
	if (cooldownTime < dmgCooldown):
		cooldownTime += delta
		if (fmod(cooldownTime,0.1) < 0.05):
			visible = false
		else:
			visible = true
	else:
		cooldownTime = dmgCooldown
		visible = true
	move_and_slide()

func take_damage(damage: float, hitAngle: float) -> void:
	if (cooldownTime == dmgCooldown):
		hp -= damage
		cooldownTime = 0.0
		velocity += Vector2(cos(hitAngle + 0.4)*(SPEED + 35),sin(hitAngle + 0.4)*(SPEED + 35))
	
	if(hp <= 0):
		queue_free()
