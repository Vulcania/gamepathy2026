class_name Enemy
extends CharacterBody2D

@onready var enemy_ai_handler: EnemyAIHandler = $EnemyAIHandler
@onready var flip_handler: FlipHandler = $Handlers/FlipHandler
@onready var movement_handler: MovementHandler = $Handlers/MovementHandler
@onready var gravity_handler: GravityHandler = $Handlers/GravityHandler
@onready var health_component: HealthComponent = $HealthComponent
@onready var healthbar: Healthbar = $Healthbar
@onready var attack_box: AttackBox = $AttackBox

var max_health = 1

func _ready() -> void:
	max_health = health_component.max_health
	attack_box.hide()

func _physics_process(delta: float) -> void:
	gravity_handler.apply_gravity(self, delta)
	enemy_ai_handler.handle_state(self, delta)
	
	move_and_slide()

func take_damage(damage_amount):
	health_component.decrease_health(damage_amount)

func _on_health_component_health_changed(current_health: int) -> void:
	healthbar.update_healthbar(current_health, max_health)

func _on_health_component_depleted_health() -> void:
	await get_tree().create_timer(1.0).timeout
	self.queue_free()

func _on_attack_box_body_entered(body: Node2D) -> void:
	if body is Player:
		enemy_ai_handler.is_attacking = true

func _on_hit_box_body_entered(body : AttackBox) -> void:
	if body.parent is Player:
		enemy_ai_handler.is_targeted = true

func _on_attack_box_body_exited(_body : Player) -> void:
	enemy_ai_handler.is_attacking = false
