extends CharacterBody2D

const SPEED : float = 300.0
const ACCEL : float = 1500.0
var yoyo_speed : float = 100.0
var target_length : float = 80.0

func _ready() -> void:
	GameState.player = self

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("arrow_left", "arrow_right", "arrow_up", "arrow_down")
	velocity = velocity.move_toward(direction * SPEED, ACCEL * delta)
	$YoyoPivot.rotation += 6.0 * delta
	
	if Input.is_action_pressed("primary"):
		target_length = 150.0
	else:
		target_length = 80.0
		
	$YoyoPivot/Yoyo.position.x = move_toward($YoyoPivot/Yoyo.position.x, target_length, yoyo_speed * delta)
	
	move_and_slide()
