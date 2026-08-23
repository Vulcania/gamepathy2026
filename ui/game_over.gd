extends Control

func _ready() -> void:
	TimerOptions.thetimer.paused = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/title_screen/title_screen.tscn")
	Global.restart_game()
