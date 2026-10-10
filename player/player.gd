extends CharacterBody2D

const SPEED : float = 300.0
const ACCEL : float = 1500.0
var yoyo_speed : float = 100.0
var target_length : float = 80.0
var health : int = 5
@export var maxHealth : int = 5
var retract_speed : float = 1.0
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
	$YoyoPivot.rotation += yoyo_speed * delta * PI/ 40
	
	if Input.is_action_pressed("primary"):
		target_length = 80.0 + health * 20
		retract_speed = 1.0
	else:
		target_length = 80.0
		retract_speed = 3.0
		
	yoyo.position.x = move_toward($YoyoPivot/Yoyo.position.x, target_length, yoyo_speed * delta * retract_speed)
	rope.scale.x = 0.62 * yoyo.position.x / 80.0
	rope.position.x = 40 + 0.5 * (yoyo.position.x - 80.0)
	move_and_slide()
