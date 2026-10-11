extends CharacterBody2D

const SPEED : float = 100.0
@export var maxHP : float = 100.0
var hp : float = maxHP
var dmgCooldown : float = 0.3
var cooldownTime : float = dmgCooldown
func _physics_process(delta: float) -> void:
	if GameState.player == null: return
	var direction = global_position.direction_to(GameState.player.global_position)
	if GameState.player.dead:
		direction *= -1
	velocity = (direction * SPEED * delta)+ velocity * (1 - delta)
	$Sprite2D.flip_h = direction.x > 0
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

func take_damage(damage: float, parent: Node2D, speed : float = 1.0) -> void:
	if (cooldownTime == dmgCooldown):
		hp -= damage
		cooldownTime = 0.0
		velocity += Vector2(cos(parent.rotation + 0.4)*(SPEED + 35)*speed,sin(parent.rotation + 0.4)*(SPEED + 35)*speed)
	
	if(hp <= 0):
		queue_free()
