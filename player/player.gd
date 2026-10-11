extends CharacterBody2D

const SPEED : float = 300.0
const ACCEL : float = 1500.0
var yoyo_speed : float = 100.0
var target_length : float = 80.0
var health : float = 5.0
@export var maxHealth : float = 5.0
var retract_speed : float = 1.0
var invincible = false
var extension_time : float = 0.0
var is_extended = false
var spinSpeed : float = 1.0
@onready var anim_sprite = $AnimatedSprite2D
@onready var rope = $YoyoPivot/Rope
@onready var yoyo = $YoyoPivot/Yoyo
func _ready() -> void:
	GameState.player = self
	anim_sprite.play("default")

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("arrow_left", "arrow_right", "arrow_up", "arrow_down")
	velocity = velocity.move_toward(direction * SPEED, ACCEL * delta)
	$YoyoPivot.rotation += (yoyo_speed - 10 * min(extension_time,6.0)) * delta * PI/ 40
	$YoyoPivot.rotation = wrapf($YoyoPivot.rotation, 0, TAU)
	spinSpeed = (yoyo_speed - 10 * min(extension_time,6.0))/yoyo_speed
	if direction != Vector2.ZERO:
		anim_sprite.speed_scale = 1.0
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				anim_sprite.play("walk_right")
			else:
				anim_sprite.play("walk_left")
		else:
			if direction.y > 0:
				anim_sprite.play("walk_down")
			else:
				anim_sprite.play("walk_up")
	else:
		anim_sprite.play("default")
		anim_sprite.pause()
		anim_sprite.frame = (int($YoyoPivot.rotation / (TAU / 8)) + 6) % 8
	if (is_extended and extension_time < 6.0):
		extension_time += delta
	elif (not is_extended and yoyo.position.x < 120.0):
		extension_time = clamp(extension_time - 10 * delta, 0.0, 6.0)
	if Input.is_action_pressed("primary"):
		target_length = 100.0 + health * 20
		is_extended = true
		retract_speed = 1.0
	else:
		target_length = 80.0
		is_extended = false
		retract_speed = 3.0
	
	yoyo.position.x = move_toward(yoyo.position.x, target_length, yoyo_speed * delta * retract_speed)
	rope.scale.x = 0.62 * yoyo.position.x / 80.0
	rope.position.x = 40 + 0.5 * (yoyo.position.x - 80.0)
	move_and_slide()
	
	var hits = $Hurtbox.get_overlapping_bodies()
	for body in hits:
		if "enemies" in body.get_groups():
			take_damage(1.0)
	
func take_damage(damage: float) -> void:
	if invincible:
		return
	health -= damage
	print("took damage. health: ", health)
	invincible = true
	$Timer.start()

func _on_timer_timeout() -> void:
	invincible = false
