extends States

var hit = false

func _enter_tree():
	randomize()
 
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Idle")
 
func exit():
	super.exit()
	owner.set_physics_process(false)

func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		hit = true
		print("ringbinder idle: hit area entered")
		owner.take_damage()
		if hit:
			hit = !hit

func transition():
	if hit:
		get_parent().change_state("Hurt")
	if owner.direction.length() <= 100 and !hit:
		get_parent().change_state("Attack")
	
