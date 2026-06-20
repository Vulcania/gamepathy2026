extends CanvasLayer


func _ready() -> void:
	$PauseMenu.visible = false

func _on_open_pause_pressed() -> void:
	$PauseMenu.visible = true
