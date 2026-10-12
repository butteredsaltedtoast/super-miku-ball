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
@onready var musicPlayer = $MusicMaker
@export var shop = CanvasLayer
var string_frames = [preload("res://Sprites/PlayerSprites/YoyoSprites/String1.png"), preload("res://Sprites/PlayerSprites/YoyoSprites/String2.png"), preload("res://Sprites/PlayerSprites/YoyoSprites/String3.png"), preload("res://Sprites/PlayerSprites/YoyoSprites/String4.png")]
var string_time : float = 0.0
func _ready() -> void:
	GameState.player = self
	GameState.level = 1
	GameState.xp = 0
	GameState.xp_to_level = 3
	GameState.run_time = 0
	for k in GameState.upgrades:
		GameState.upgrades[k] = 0
	anim_sprite.play("default")
	$MusicMaker2.stop()
	$MusicMaker.play()
	$MusicMaker3.stop()
	shop.closeShop.connect(_close_menu)
	
func _close_menu():
	crossfade($MusicMaker3, $MusicMaker)

func _physics_process(delta: float) -> void:
	if (GameState.inMenu):
		if not $MusicMaker3.playing:
			crossfade($MusicMaker, $MusicMaker3)
		return
	if dead and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		return
	elif dead:
		return
	GameState.run_time += delta
	yoyo_speed = 100 * (1 + 0.15 * GameState.upgrades["speed"])
	yoyo.scale = Vector2.ONE * (1 + 0.2 * GameState.upgrades["size"])
	maxHealth = 10.0 + 2.0 * GameState.upgrades["maxhp"]
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
		target_length = 100.0 + health * [20, 26, 32][GameState.upgrades["stretch"]]
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
		if not body.is_in_group("enemies"):
			continue
		if yoyo.overlaps_body(body) or body.cooldownTime < body.dmgCooldown:
			continue
		if target_length > yoyo.position.x - 10:
			take_damage(1.0, true)
	
func take_damage(damage: float, from_string := false) -> void:
	if invincible or dead:
		return
	health -= damage
	if health <= 0:
		dead = true
		GameState.play_sfx("res://Audio/SFX/snd_death.mp3")
		$YoyoPivot.visible = false
		yoyo.set_deferred("monitoring", false)
		anim_sprite.play("death")
		crossfade($MusicMaker, $MusicMaker2, 1)
		create_tween().tween_property(get_tree().current_scene.get_node("%DeathLabel"), "modulate:a", 1.0, 1.0)
		return
	if from_string:
		GameState.play_sfx("res://Audio/SFX/snd_string_hurt.mp3")
	else:
		GameState.play_sfx("res://Audio/SFX/snd_hurt.mp3")
	invincible = true
	$Timer.start()

func _on_timer_timeout() -> void:
	invincible = false
	
func crossfade(from, to, time := 0.6):
	to.volume_db = -40
	to.play(from.get_playback_position())
	var t = create_tween().set_parallel(true)
	t.tween_property(to, "volume_db", 0.0, time)
	t.tween_property(from, "volume_db", -40.0, time)
	t.chain().tween_callback(from.stop)
