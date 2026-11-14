extends Button

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	GameSettings.player_count = 1
	get_tree().paused = false
	get_tree().reload_current_scene()
