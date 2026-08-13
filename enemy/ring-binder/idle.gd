extends States

func _enter_tree():
	randomize()
 
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Idle")
 
func exit():
	super.exit()
	owner.set_physics_process(false)
 
func transition():
	if owner.hit:
		get_parent().change_state("Hurt")
	if owner.direction.length() <= 100 and !owner.hit:
		get_parent().change_state("Attack")
	
