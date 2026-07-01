extends Control


@onready var menu_vbox = $Menu
@onready var options_vbox = $Options
@onready var credits_vbox = $Credits
@onready var music_slider: HSlider = $Options/OptionsVBox/MusicSlider
@onready var sfx_slider: HSlider = $Options/OptionsVBox/SfxSlider


func _ready() -> void:
	menu_vbox.visible = true
	options_vbox.visible = false
	credits_vbox.visible = false
	music_slider.value = Options.get_current_music_volume()
	sfx_slider.value = Options.get_current_effect_volume()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level/opening_animatic.tscn")
	#get_tree().change_scene_to_file("res://level/test_level.tscn")


func _on_options_button_pressed() -> void:
	menu_vbox.visible = false
	options_vbox.visible = true
	credits_vbox.visible = false


func _on_credits_button_pressed() -> void:
	menu_vbox.visible = false
	options_vbox.visible = false
	credits_vbox.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	menu_vbox.visible = true
	options_vbox.visible = false
	credits_vbox.visible = false



func _on_music_slider_value_changed(value: float) -> void:
	Options.change_music_volume(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	Options.change_sfx_volume(value)
