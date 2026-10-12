extends Area2D


func _on_body_entered(body: Node2D) -> void:
	#print(body.get_groups())
	if body.is_in_group("enemies"):
		body.take_damage([25, 35, 50][GameState.upgrades["damage"]],get_parent(),position.x/80)
