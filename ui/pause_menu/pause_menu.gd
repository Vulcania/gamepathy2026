extends Control

@onready var quit = $DoYouWantToQuit

func _ready() -> void:
	quit.visible = false

func _on_music_h_slider_value_changed(value: float) -> void:
	Options.change_music_volume(value)

func _on_sfx_h_slider_value_changed(value: float) -> void:
	Options.change_sfx_volume(value)

func _on_close_pause_pressed() -> void:
	$".".visible = false

func _on_quit_run_pressed() -> void:
	quit.visible = true

func _on_yes_pressed() -> void:
	pass # Replace with function body.

func _on_no_pressed() -> void:
	quit.visible = false
