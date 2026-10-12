extends Node
var player : CharacterBody2D
var inMenu = false
var xp : float = 0
var xp_to_level : float = 5
var level : int = 1
@export var UI : CanvasLayer
signal updateLevel
signal closeShop
func add_xp(amount: float) -> void:
	xp += amount
	if xp >= xp_to_level:
		xp -= xp_to_level
		level += 1
		xp_to_level *= 1.4
		player.health = min(player.health + 3, player.maxHealth) #temporary
		updateLevel.emit(level)
		inMenu = true
