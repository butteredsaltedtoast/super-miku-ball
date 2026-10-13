extends Control

func _ready() -> void:
	$StartButton.pressed.connect(func(): get_tree().change_scene_to_file("res://levels/main_arena.tscn"))
	$StartButton.grab_focus()
