extends BossState

func enter():
	super.enter()
	animation_player.play("death")
 
func boss_slained():
	Global.boss_deafeated = true
	if Global.round_one:
		Dialogic.start("res://dialog/timelines/Boney_FirstDefeat.dtl")
	if Global.round_two:
		Dialogic.start("res://dialog/timelines/Boney_SecondDefeat.dtl")
	if Global.round_three:
		Dialogic.start("res://dialog/timelines/Boney_ThirdDefeat.dtl")
	owner.hide()
