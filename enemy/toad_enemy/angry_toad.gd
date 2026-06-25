extends StaticBody2D

@onready var animation = $AnimationPlayer

var dead = false

var max_health = 5
var current_health = 5
var hit = false

func _ready():
	current_health = max_health
	animation.play("Idle")

func _on_detect_player_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !dead && !hit:
		animation.play("Attack")
		await get_tree().create_timer(2).timeout

func _on_detect_player_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player && !dead && !hit:
		animation.play("Idle")

func get_hit():
	hit = !hit
	
	if hit && !dead:
		animation.play("Hit")
		current_health -= 1
		get_node("Healthbar").update_healthbar(current_health, max_health)
		
		if current_health <= 0:
			die()

func die():
	animation.play("Death")
