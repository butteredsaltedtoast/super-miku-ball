extends Node
var player : CharacterBody2D
var inMenu = false
var xp : float = 0
var xp_to_level : float = 10
var level : int = 1

func add_xp(amount: float) -> void:
	xp += amount
	if xp >= xp_to_level:
		xp -= xp_to_level
		level += 1
		xp_to_level *= 1.5
