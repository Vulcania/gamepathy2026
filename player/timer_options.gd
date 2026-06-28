extends Control


@onready var timelabel = $TimeLeft
@onready var thetimer = $Timer
#@onready var pausemenu = preload("res://ui/pause_menu/pause_menu.gd")


func _ready() -> void:
	BuffSelectionOne.option_one.connect(_on_option_3)
	PauseMenu.game_paused.connect(timer_paused)
	PauseMenu.game_resumed.connect(timer_unpaused)

func time_left_until_late():
	var time_left = thetimer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return[minute, second]

func _on_timer_timeout() -> void:
	pass # Replace with function body.

func _process(delta):
	timelabel.text = "%02d:%02d" % time_left_until_late()

func timer_paused():
	thetimer.pause = true

func timer_unpaused():
	thetimer.pause = false

func _on_option_3():
	thetimer.wait_time += 10
	if not thetimer.is_stopped():
		thetimer.time_left += 10
