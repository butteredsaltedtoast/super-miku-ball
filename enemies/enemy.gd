extends CharacterBody2D

class_name Enemy

const SPEED : float = 100.0
@export var maxHP : float = 75.0
var hp : float = maxHP
var dmgCooldown : float = 0.3
var cooldownTime : float = dmgCooldown
var dying = false
func _physics_process(delta: float) -> void:
	if dying: return
	if $Sprite2D.animation == "hit" and not $Sprite2D.is_playing():
		$Sprite2D.play("default")
	if GameState.inMenu: return
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
		GameState.play_sfx("res://Audio/SFX/snd_enemy_hurt.mp3")
		cooldownTime = 0.0
		velocity += Vector2(cos(parent.rotation + 0.4)*(SPEED + 35)*speed,sin(parent.rotation + 0.4)*(SPEED + 35)*speed)
	
		if(hp <= 0):
			dying = true
			visible = true
			remove_from_group("enemies")
			$CollisionShape2D.set_deferred("disabled", true)
			GameState.add_xp(1)
			GameState.play_sfx("res://Audio/SFX/snd_player_hurt.mp3")
			$Sprite2D.play("death")
			$Sprite2D.animation_finished.connect(func():
				var t = create_tween()
				t.tween_property(self, "modulate:a", 0.0, 0.4)
				t.tween_callback(queue_free)
			)
		else:
			$Sprite2D.play("hit")
