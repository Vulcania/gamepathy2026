extends Node2D



func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/title_screen/title_screen.tscn")
