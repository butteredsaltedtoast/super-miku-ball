extends CanvasLayer
signal updateLevel
signal closeShop
@onready var cards = [$ShopBG/Card1, $ShopBG/Card2, $ShopBG/Card3, $ShopBG/Card4]
var card_names = {"damage": "YoyoDamage", "size": "YoyoSize", "speed": "YoyoSpeed", "stretch": "StringStretch", "cradle": "Cradle", "loopdeloop": "LoopDeLoop", "parry": "Parry", "walkthedog": "WalkTheDog"}
var cantake = []

func _ready() -> void:
	visible = false
	GameState.updateLevel.connect(_onShopOpen)
	for k in 4:
		cards[k].pressed.connect(_on_card_picked.bind(k))
	pass

func _process(delta: float) -> void:
	pass
	
func _onShopOpen(level: int):
	visible = true
	var pool = []
	for k in GameState.upgrades:
		if GameState.upgrades[k] < GameState.max_upgrades[k]:
			pool.append(k)
	pool.shuffle()
	cantake = pool.slice(0, 4)
	for k in 4:
		if(k < cantake.size()):
			var j = cantake[k]
			var file = card_names[j]
			if GameState.max_upgrades[j] > 1:
				file += str(GameState.upgrades[j] + 1)
			cards[k].texture_normal = load("res://Sprites/UI/"+file+".png")
			cards[k].visible = true
		else:
			cards[k].visible = false

func _on_card_picked(k: int):
	GameState.upgrades[cantake[k]] += 1
	visible = false
	GameState.inMenu = false
	closeShop.emit()
