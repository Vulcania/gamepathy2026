extends CanvasLayer

@onready var timelabel = $TimeLeft
@onready var thetimer = $Timer

func _ready() -> void:
#	BuffSelectionOne.option_one.connect(_on_option_3)
#	PauseMenu.game_paused.connect(timer_paused)
#	PauseMenu.game_resumed.connect(timer_unpaused)
	Dialogic.signal_event.connect(_on_dialogic_signal)

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
	thetimer.paused = true

func timer_unpaused():
	thetimer.paused = false

func _on_dialogic_signal(argument: String):
	if argument == "option3_selected":
		thetimer.wait_time += 10
#		if not thetimer.is_stopped():
#			thetimer.time_left += 10

#func _on_option_3():
#	thetimer.wait_time += 10
#	if not thetimer.is_stopped():
#		thetimer.time_left += 10
