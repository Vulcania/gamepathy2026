extends VBoxContainer

func _on_music_slider_value_changed(value: float) -> void:
	Options.change_music_volume(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	Options.change_sfx_volume(value)
