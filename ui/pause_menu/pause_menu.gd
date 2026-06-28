extends Control
#class_name PauseMenu 

signal game_paused
signal game_resumed

@onready var quit = $DoYouWantToQuit

func _ready() -> void:
	#quit.visible = false
	hide()

func _input(event):
	if event.is_action_pressed("pausemenu"):
		show()
		game_paused.emit()

func _on_music_h_slider_value_changed(value: float) -> void:
	Options.change_music_volume(value)

func _on_sfx_h_slider_value_changed(value: float) -> void:
	Options.change_sfx_volume(value)

func _on_close_pause_pressed() -> void:
	hide()
	game_resumed.emit()

func _on_quit_run_pressed() -> void:
	quit.visible = true

func _on_yes_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/title_screen/title_screen.tscn")

func _on_no_pressed() -> void:
	quit.visible = false
