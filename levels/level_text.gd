extends Label
signal updateLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.updateLevel.connect(_updateLevel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _updateLevel(level: int):
	text = "Level " + str(level)
