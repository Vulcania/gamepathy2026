extends Control

@onready var quit = $DoYouWantToQuit

func _ready() -> void:
	quit.visible = false
	hide()
	if Input.is_action_pressed("pausemenu"):
		show()

func _on_music_h_slider_value_changed(value: float) -> void:
	Options.change_music_volume(value)

func _on_sfx_h_slider_value_changed(value: float) -> void:
	Options.change_sfx_volume(value)

func _on_close_pause_pressed() -> void:
	hide()

func _on_quit_run_pressed() -> void:
	quit.visible = true

func _on_yes_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/title_screen/title_screen.tscn")

func _on_no_pressed() -> void:
	quit.visible = false
