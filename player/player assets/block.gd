extends Panel

@onready var sprite = $Sprite2D

func update(whole : bool):
	if whole:
		sprite.show()
	else:
		sprite.hide()
