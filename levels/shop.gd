extends CanvasLayer
signal updateLevel
signal closeShop
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	GameState.updateLevel.connect(_onShopOpen)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if visible:
			if Input.is_action_just_pressed("primary"):
				visible = false
				closeShop.emit()
				GameState.inMenu = false
func _onShopOpen(level: int):
	visible = true
	if Input.is_action_just_pressed("primary"):
		visible = false
		closeShop.emit()
		GameState.inMenu = false
	pass
