extends CharacterBody2D

@onready var collision = $"../../PlayerDetection/CollisionShape2D" 
@onready var player = get_parent().find_child("Player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var progress_bar = $UI/ProgressBar
@onready var camera: Camera2D = get_tree().get_first_node_in_group("Camera")
@export var minion_node : PackedScene = preload("res://enemy/ring-binder/ring-binder.tscn")

var direction : Vector2

enum State {IDLE, FOLLOW, ATTACK, HIT, TELEPORT, SPAWNMINION, DEATH}

var new_state : State

var current_state: State = State.IDLE
var previous_state: State

var is_attacking = false
var is_hit = false
var is_dead = false

var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
		progress_bar.set_deferred("visible",value)
		
var player_out_of_reach = false
 
var health: = 100:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			is_dead = true

func _ready():
	#set_physics_process(false)
	
	current_state = State.IDLE
 
func _process(_delta):
	direction = player.position - position
 
	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false

func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)
 
#idle
func _on_player_detection_body_entered(body):
	if body.get_parent() is Player:
		print("player entered boss detection")
		player_entered = true

func take_damage():
	health -= 5
	$SFX/Hurt.play()

func handle_state(entity : CharacterBody2D, delta : float) -> void:
	new_state = check_state()
	if new_state != current_state:
		current_state = new_state
		match current_state:
			State.IDLE:
				pass
			State.FOLLOW:
				set_physics_process(true)
			State.ATTACK:
				set_physics_process(true)
			State.TELEPORT:
				set_physics_process(true)
				#position = player.position + Vector2.RIGHT * 40
			State.SPAWNMINION:
				set_physics_process(true)
			State.DEATH:
				set_physics_process(true)
		_update_animation()


func check_state():
	if player_entered:
		return State.FOLLOW
	
	if owner.direction.length() < 160 and !is_dead:
		return State.ATTACK
		
	if owner.direction.length() > 250 and !is_dead:
		var chance = randi() % 2
		match chance:
			0:
				return State.SPAWNMINION
			1:
				return State.TELEPORT
	
	if is_dead:
		return State.DEATH
	
	
	return State.IDLE

func _update_animation():
	match current_state:
		State.IDLE:
			if !is_dead:
				animation_player.play("idle")
				return
		State.FOLLOW:
			if !is_dead:
				animation_player.play("idle")
				return
		State.ATTACK:
			combo()
			await animation_player.animation_finished
			if owner.direction.length() > 260:
				return State.FOLLOW
		State.TELEPORT:
			animation_player.play("skill")
			await animation_player.animation_finished
		State.SPAWNMINION:
			animation_player.play("summon")
			await animation_player.animation_finished
		State.HIT:
			animation_player.play("hit")
			await animation_player.animation_finished
			return
		State.DEATH:
			animation_player.play("death")
			await animation_player.animation_finished
			return
	return State.IDLE

#attack
func attack(move = "1"):
	animation_player.play("attack_" + move)
	await animation_player.animation_finished

func combo():
	var move_set = ["1","1","2"]
	for i in move_set:
		await attack(i)
	combo()

func _on_attack_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().take_damage(1)
		camera.trigger_shake()

func teleport():
	owner.position = player.position + Vector2.RIGHT * 40

func spawn():
	var minion = minion_node.instantiate()
	minion.position = owner.position + Vector2(40,-40)
	get_tree().current_scene.add_child(minion)

func boss_slained():
	Global.boss_deafeated = true
	if Global.round_one:
		Dialogic.start("res://dialog/timelines/Boney_FirstDefeat.dtl")
	if Global.round_two:
		Dialogic.start("res://dialog/timelines/Boney_SecondDefeat.dtl")
	if Global.round_three:
		Dialogic.start("res://dialog/timelines/Boney_ThirdDefeat.dtl")
	hide()
