extends CanvasLayer
signal updateLevel
signal closeShop
@onready var cards = [$ShopBG/Card1, $ShopBG/Card2, $ShopBG/Card3, $ShopBG/Card4]
@onready var shop_target = $ShopBG.position
var card_names = {"damage": "SpikeYoyo", "size": "YoyoSize", "speed": "YoyoSpeed", "stretch": "StringStretch", "maxhp": "StringMax", "cradle": "Cradle", "loopdeloop": "LoopDeLoop", "parry": "Parry", "walkthedog": "WalkTheDog"}
var card_descs = {
	"damage": "Yoyo hits harder!",
	
}
var cantake = []

func _ready() -> void:
	visible = false
	GameState.updateLevel.connect(_onShopOpen)
	for k in 4:
		cards[k].pressed.connect(_on_card_picked.bind(k))
	$ShopBG/Refuse.pressed.connect(func(): GameState.play_sfx("res://Audio/SFX/snd_confirm.mp3"); _close_shop())
	pass

func _process(delta: float) -> void:
	pass
	
func _onShopOpen(level: int):
	GameState.play_sfx("res://Audio/SFX/snd_shop_alert.mp3")
	visible = true
	$ShopBG.position = shop_target + Vector2(0, 400)
	create_tween().tween_property($ShopBG, "position", shop_target, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var pool = []
	for k in GameState.upgrades:
		if GameState.upgrades[k] >= GameState.max_upgrades[k]:
			continue
		if GameState.max_upgrades[k] == 1 and GameState.actives.size() >= 2:
			continue
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

func _close_shop():
	visible = false
	GameState.inMenu = false
	closeShop.emit()

func _on_card_picked(k: int):
	GameState.play_sfx("res://Audio/SFX/snd_shop_purchase.mp3")
	GameState.upgrades[cantake[k]] += 1
	if GameState.max_upgrades[cantake[k]] == 1:
		GameState.actives.append(cantake[k])
	if cantake[k] == "maxhp":
		GameState.player.health += 2
	_close_shop()
