class_name Enemy
extends CharacterBody2D

@onready var enemy_ai_handler: EnemyAIHandler = $EnemyAIHandler
@onready var gravity_handler: GravityHandler = $Handlers/GravityHandler
@onready var health_component = $HealthComponent
@onready var healthbar: Healthbar = $Healthbar
@onready var attack_box: AttackBox = $AttackBox

var max_health = 1
var direction : Vector2
var is_flying : bool

func _ready() -> void:
	max_health = health_component.max_health
	attack_box.hide()
	is_flying = enemy_ai_handler.is_flying

func _physics_process(delta: float) -> void:
	enemy_ai_handler.handle_state(self, delta)
	
	if is_flying:
		velocity = direction.normalized() * 60
	else:
		gravity_handler.apply_gravity(self, delta)
	
	move_and_slide()

func take_damage(damage_amount):
	health_component.decrease_health(damage_amount)
	print("Deer Taking damage")

func _on_health_component_health_changed(current_health: int) -> void:
	healthbar.update_healthbar(current_health, max_health)
	print("Deer Health is Updated")

func _on_health_component_depleted_health() -> void:
	if $AnimationPlayer.current_animation == "dying":
		await $AnimationPlayer.animation_finished
		self.queue_free()

func _on_attack_box_body_exited(_body : Player) -> void:
	enemy_ai_handler.is_attacking = false
	print("Player left me")

func _on_hit_box_area_entered(area: Area2D) -> void:
	print("base enemy: on hit box area entered", area.name)
	if area.get_parent() is Player:
		print("hitbox area Deer Is getting hit")
		enemy_ai_handler.is_targeted = true
		take_damage(1)
		await get_tree().create_timer(1.0).timeout
		enemy_ai_handler.is_targeted = false

func _on_attack_box_area_entered(area: Area2D) -> void:
		if area.get_parent() is Player:
			print("deear area attacking player")
			area.get_parent().take_damage(1)

func _on_monitor_area_body_entered(body: Node2D) -> void:
	if body is Player:
		enemy_ai_handler.is_attacking = true
		print("attackbox body: Deer Is attacking")
