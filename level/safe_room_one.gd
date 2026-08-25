extends Node2D

var is_in_door_area = false

func ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	$Door2/pressE.hide()
	TimerOptions.timer_deactivated()


func rounds():
	if Global.round_one:
		$Enemies/RoundOne.show()
		$Enemies/RoundTwo.hide()
		$Enemies/RoundThree.hide()
		TimerOptions.timer_paused()
		
	if Global.round_two:
		$Enemies/RoundOne.hide()
		$Enemies/RoundTwo.show()
		$Enemies/RoundThree.hide()
		$Onboarding.queue_free()
		TimerOptions.timer_activated()
		TimerOptions.timer_unpaused()
		
	if Global.round_three:
		$Enemies/RoundOne.hide()
		$Enemies/RoundTwo.hide()
		$Enemies/RoundThree.show()
		$Onboarding.queue_free()
		TimerOptions.timer_activated()
		TimerOptions.timer_unpaused()

func _input(event):
	if event.is_action_pressed("interact"):
		if is_in_door_area:
			$AnimationPlayer.play("EnterLevelOne")
			#level change in animation player

func _on_door_area_area_entered(area):
	if area.get_parent() is Player:
		$Door2/pressE.show()
		is_in_door_area = true

func _on_door_area_area_exited(area):
	if area.get_parent() is Player:
		$Door2/pressE.hide()
		is_in_door_area = false


func _on_dialogic_signal(argument: String):
	if argument == "":
		pass

func enter_level_one():
	get_tree().change_scene_to_file("res://level/level_one.tscn")
#in AnimationPlayer
