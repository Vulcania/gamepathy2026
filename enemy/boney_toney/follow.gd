extends BossState

func _enter_tree():
	randomize()
 
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("idle")
 
func exit():
	super.exit()
	owner.set_physics_process(false)
 
func transition():
	if owner.direction.length() < 160:
		get_parent().change_states("Attack")
	if owner.direction.length() > 250:
		var chance = randi() % 2
		match chance:
			0:
				get_parent().change_states("SpawnMinion")
			1:
				get_parent().change_states("Teleport")
