extends Node

func _ready() -> void:
	get_tree().paused = false
	$TutorialTexts/Tutorialbox.hide()
	$TutorialTexts/tomove.hide()
	$TutorialTexts/toattackandblock.hide()
	$TutorialTexts/tointeract.hide()
	$TutorialTexts/topause.hide()
	$TutorialTexts/timerinnextlevel.hide()



func _on_o_btomove_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		$TutorialTexts/Tutorialbox.show()
		$TutorialTexts/tomove.show()
		get_tree().paused = true

func _on_o_btoattackandblock_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		$TutorialTexts/Tutorialbox.show()
		$TutorialTexts/toattackandblock.show()
		get_tree().paused = true

func _on_o_btointeract_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		$TutorialTexts/Tutorialbox.show()
		$TutorialTexts/tointeract.show()
		get_tree().paused = true

func _on_obtopause_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		$TutorialTexts/Tutorialbox.show()
		$TutorialTexts/topause.show()
		get_tree().paused = true

func _on_o_btimerinnextlevel_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		$TutorialTexts/Tutorialbox.show()
		$TutorialTexts/timerinnextlevel.show()
		get_tree().paused = true


func _on_got_it_pressed() -> void:
	get_tree().paused = false
	$TutorialTexts/Tutorialbox.hide()
	$TutorialTexts/tomove.hide()
	$TutorialTexts/toattackandblock.hide()
	$TutorialTexts/tointeract.hide()
	$TutorialTexts/topause.hide()
	$TutorialTexts/timerinnextlevel.hide()
