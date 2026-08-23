extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar
 
var direction : Vector2
 
var health: = 100:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_states("Death")
 
func _ready():
	set_physics_process(false)
 
func _process(_delta):
	direction = player.position - position
 
	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
 
func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)
 
func take_damage():
	health -= 5
	print("boney_toney, take damage. Health:", health)
	$SFX/Hurt.play()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		print("boney_toney: hitbox area entered")
		take_damage()
