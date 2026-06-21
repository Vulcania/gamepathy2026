extends CanvasLayer


func _ready() -> void:
	$PauseMenu.visible = false

func _on_open_pause_pressed() -> void:
	$PauseMenu.visible = true

func open_pause_per_p():
	if Input.is_action_pressed("pause"):
		$PauseMenu.visible = true
