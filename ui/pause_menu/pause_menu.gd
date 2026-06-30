extends Control
#class_name PauseMenu 

signal game_paused
signal game_resumed

@onready var quit = $DoYouWantToQuit
@onready var currentspeedlabel = $CollectedBuffs/HBoxContainer/SpeedBuffData/CurrentSpeedData
@onready var currentblocklabel = $CollectedBuffs/HBoxContainer/BlockBuffData/CurrentBlockData
@onready var currenttimerlabel = $CollectedBuffs/HBoxContainer/TimerBuffData/CurrentTimerData

func _ready() -> void:
	#quit.visible = false
	BuffSelectionOne.option_one.connect(_on_option_1)
	BuffSelectionOne.option_two.connect(_on_option_2)
	BuffSelectionOne.option_three.connect(_on_option_3)
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

func _on_option_1():
	currentspeedlabel.text += 5

func _on_option_2():
	currentblocklabel.text += 1

func _on_option_3():
	currenttimerlabel.text += 10
