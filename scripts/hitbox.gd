extends Area2D
class_name Hitbox

var damage_dealt : int
var hitbox_shape : CollisionShape2D
var hitbox_lifetime : float

#Initialize variables
func _init(_damage_dealt : int, _hitbox_shape : CollisionShape2D, _hitbox_lifetime : float) -> void:
	damage_dealt = _damage_dealt
	hitbox_shape = _hitbox_shape
	hitbox_lifetime = _hitbox_lifetime
	
func _ready() -> void:
	monitorable = false # Can't be detected by other shapes
	area_entered.connect(_on_area_entered)
	
	if hitbox_lifetime > 0.0:
		var new_timer = Timer.new()
		add_child(new_timer)
		new_timer.timeout.connect(queue_free)
		new_timer.call_deferred("start", hitbox_lifetime)
	
	if hitbox_shape:
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = hitbox_shape
		add_child(collision_shape)
	
	collision_layer = 2
	collision_mask = 0
	
func _on_area_entered(area: Area2D) -> void:
	if not area.has_method("receive_hit"):
		return
	
	area.receive_hit(damage_dealt)
