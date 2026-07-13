extends Control
#class_name PauseMenu 

@onready var quit = $DoYouWantToQuit
@onready var currentspeedlabel = $CollectedBuffs/HBoxContainer/SpeedBuffData/CurrentSpeedData
@onready var currentblocklabel = $CollectedBuffs/HBoxContainer/BlockBuffData/CurrentBlockData
@onready var currenttimerlabel = $CollectedBuffs/HBoxContainer/TimerBuffData/CurrentTimerData

var speedbuffcount = 0
var blockbuffcount = 3
var timerbuffcount = 0

func _ready() -> void:
	get_tree().paused = false
	#quit.visible = false
	#BuffSelectionOne.option_one.connect(_on_option_1)
	#BuffSelectionOne.option_two.connect(_on_option_2)
	#BuffSelectionOne.option_three.connect(_on_option_3)
	#BuffSelectionTwo.option_one.connect(_on_option_1)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	hide()

func _input(event: InputEvent):
	if event.is_action_pressed("pausemenu"):
		$ButtonPressSound.play()
		
		if get_tree().paused:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true

func _on_music_h_slider_value_changed(value: float) -> void:
	Options.change_music_volume(value)

func _on_sfx_h_slider_value_changed(value: float) -> void:
	Options.change_sfx_volume(value)

func _on_close_pause_pressed() -> void:
	$ButtonPressSound.play()
	hide()
	get_tree().paused = false

func _on_quit_run_pressed() -> void:
	$ButtonPressSound.play()
	quit.visible = true

func _on_yes_pressed() -> void:
	$ButtonPressSound.play()
	get_tree().change_scene_to_file("res://ui/title_screen/title_screen.tscn")

func _on_no_pressed() -> void:
	$ButtonPressSound.play()
	quit.visible = false


func _on_dialogic_signal(argument: String):
	if argument == "option1_selected":
		speedbuffcount += 10
		if speedbuffcount == 10:
			currentspeedlabel.text = "+10%"
		if speedbuffcount == 20:
			currentspeedlabel.text = "+20%"
		if speedbuffcount == 30:
			currentspeedlabel.text = "+30%"
		if speedbuffcount == 40:
			currentspeedlabel.text = "+40%"
	if argument == "option2_selected":
		blockbuffcount += 1
		if blockbuffcount == 3:
			currentblocklabel.text = "+3"
		if blockbuffcount == 4:
			currentblocklabel.text = "+4"
		if blockbuffcount == 5:
			currentblocklabel.text = "+5"
	if argument == "option3_selected":
		timerbuffcount += 10
		if timerbuffcount == 10:
			currenttimerlabel.text = "+10s"
		if timerbuffcount == 20:
			currenttimerlabel.text = "+20s"
		if timerbuffcount == 30:
			currenttimerlabel.text = "+30s"

#func _on_option_1():

#func _on_option_2():

#func _on_option_3():
