extends StaticBody2D

@onready var animation = $AnimationPlayer

var dead = false

var max_health = 3
var current_health = 3
var hit = false

func _ready():
	current_health = max_health
	animation.play("Idle")

func _on_detect_player_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !dead && !hit:
		print("toad detects player")
		animation.play("Attack")
		await get_tree().create_timer(2).timeout

func _on_detect_player_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player && !dead && !hit:
		animation.play("Idle")
		print("player left me, the sequel by toad")

func get_hit():
	hit = !hit
	
	if hit && !dead:
		print("toad got hit, health left: ", current_health)
		animation.play("Hit")
		current_health -= 1
		get_node("Healthbar").update_healthbar(current_health, max_health)
		
		if current_health <= 0:
			die()

func die():
	print("toad died")
	animation.play("Death")

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player and !dead:
		get_hit()

func _on_attack_box_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player and !hit:
			print("toad area attacking player")
			area.get_parent().take_damage(1)
