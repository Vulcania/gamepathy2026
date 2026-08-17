extends HBoxContainer

@onready var heart_gui_class = preload("res://ui/heart.tscn")

func set_max_hearts(max_hearts: int):
	for i in range(max_hearts):
		var heart = heart_gui_class.instantiate()
		add_child(heart)

func update_hearts(current_health):
	print("hearts container updated")
	print("healths container", current_health)
	var hearts = get_children()
	
	for i in range(current_health):
		hearts[i].update(true)
		print("hearts container updated true")
	
	for i in range(current_health, hearts.size()):
		hearts[i].update(false)
		print("hearts container updated false")
