extends Area2D

var game_over_active: bool = false
@onready var game_over = get_tree().current_scene.get_node("GameOver")

func _ready() -> void:
	game_over.hide()
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not get_parent().visible:
		return
	if game_over_active:
		return

	if body.is_in_group("players"):
		game_over_active = true
		if body.has_method("die"):
			body.die(get_parent().name)
		else:
			game_over.show()
			get_tree().paused = true
