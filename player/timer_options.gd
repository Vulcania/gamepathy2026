extends CanvasLayer

@onready var timelabel = $TimeLeft
@onready var thetimer = $Timer

var you_are_late = false

func _ready() -> void:
#	BuffSelectionOne.option_one.connect(_on_option_3)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	

func rounds():
	if Global.round_two:
		thetimer.wait_time += 300
		you_are_late = false
	if Global.round_three:
		thetimer.wait_time += 300
		you_are_late = false

func restart_game():
	thetimer.wait_time = 300
	you_are_late = false

func time_left_until_late():
	var time_left = thetimer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return[minute, second]

func _on_timer_timeout() -> void:
	you_are_late = true

func _process(delta):
	timelabel.text = "%02d:%02d" % time_left_until_late()

func timer_paused():
	thetimer.paused = true

func timer_unpaused():
	thetimer.paused = false

func timer_deactivated():
	thetimer.paused = true
	hide()

func timer_activated():
	show()

func _on_dialogic_signal(argument: String):
	if argument == "option3_selected":
		thetimer.wait_time += 10

#func _on_option_3():
#	thetimer.wait_time += 10
#	if not thetimer.is_stopped():
#		thetimer.time_left += 10
