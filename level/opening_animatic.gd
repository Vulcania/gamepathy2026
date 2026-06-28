extends Sprite2D

func enter_level_one():
	get_tree().change_scene_to_file("res://level/safe_room_one.tscn")

func _on_skip_pressed() -> void:
	get_tree().change_scene_to_file("res://level/safe_room_one.tscn")
