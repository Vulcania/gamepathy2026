extends BossState

var can_transition: bool = false
 
func enter():
	super.enter()
	animation_player.play("skill")
	await animation_player.animation_finished
	can_transition = true
 
func teleport():
	owner.position = player.position + Vector2.RIGHT * 200 + Vector2.UP * 50

func transition():
	if can_transition:
		#await get_tree().create_timer(1).timeout
		get_parent().change_states("Attack")
		can_transition = false
