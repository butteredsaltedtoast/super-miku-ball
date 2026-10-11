extends CharacterBody2D

const SPEED : float = 300.0
const ACCEL : float = 1500.0
var yoyo_speed : float = 100.0
var target_length : float = 80.0
@export var maxHealth : float = 10.0
var health : float = maxHealth
var dead = false
var retract_speed : float = 1.0
var invincible = false
var extension_time : float = 0.0
var is_extended = false
var spinSpeed : float = 1.0
@onready var anim_sprite = $AnimatedSprite2D
@onready var rope = $YoyoPivot/Rope/Rope
@onready var ropeCollide = $YoyoPivot/Rope/Collide
@onready var yoyo = $YoyoPivot/Yoyo
@onready var ropeShape = $YoyoPivot/Rope/Collide/CollisionShape2D
var string_frames = [preload("res://Sprites/PlayerSprites/YoyoSprites/String1.png"), preload("res://Sprites/PlayerSprites/YoyoSprites/String2.png"), preload("res://Sprites/PlayerSprites/YoyoSprites/String3.png"), preload("res://Sprites/PlayerSprites/YoyoSprites/String4.png")]
var string_time : float = 0.0
func _ready() -> void:
	GameState.player = self
	anim_sprite.play("default")

func _physics_process(delta: float) -> void:
	if dead and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		return
	elif dead:
		return
	var direction := Input.get_vector("arrow_left", "arrow_right", "arrow_up", "arrow_down")
	velocity = velocity.move_toward(direction * SPEED, ACCEL * delta)
	$YoyoPivot.rotation += (yoyo_speed - 10 * min(extension_time,6.0)) * delta * PI/ 40
	$YoyoPivot.rotation = wrapf($YoyoPivot.rotation, 0, TAU)
	spinSpeed = (yoyo_speed - 10 * min(extension_time,6.0))/yoyo_speed
	if yoyo.position.x == 80.0 and direction != Vector2.ZERO:
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
	
	yoyo.position.x = move_toward(yoyo.position.x, target_length, yoyo_speed * delta * retract_speed * health / 4)
	rope.region_rect = Rect2(0, 0, yoyo.position.x / rope.scale.x, 5)
	ropeShape.shape.size = Vector2((yoyo.position.x - 30) / 3, 5)
	ropeShape.position.x = (yoyo.position.x - 30) / 6
	string_time += delta
	rope.texture = string_frames[int(string_time * 10) % 4]
	move_and_slide()
	
	var hits = $Hurtbox.get_overlapping_bodies()
	for body in hits:
		if "enemies" in body.get_groups():
			take_damage(1.0)
	var ropehits = ropeCollide.get_overlapping_bodies()
	for body in ropehits:
		if yoyo.overlaps_body(body):
			continue
		if "enemies" in body.get_groups():
			take_damage(2.0)
	
func take_damage(damage: float) -> void:
	if invincible or dead:
		return
	health -= damage
	if health <= 0:
		dead = true
		$YoyoPivot.visible = false
		yoyo.set_deferred("monitoring", false)
		anim_sprite.play("death")
		create_tween().tween_property(get_tree().current_scene.get_node("%DeathLabel"), "modulate:a", 1.0, 1.0)
		return
	print("took damage. health: ", health)
	invincible = true
	$Timer.start()

func _on_timer_timeout() -> void:
	invincible = false
