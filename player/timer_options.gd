extends Control

@onready var timelabel = $TimeLeft
@onready var thetimer = $Timer

func time_left_until_late():
	var time_left = thetimer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return[minute, second]

func _on_timer_timeout() -> void:
	pass # Replace with function body.

func _process(delta):
	timelabel.text = "%02d:%02d" % time_left_until_late()
