extends Area2D

@onready var game_over = get_tree().current_scene.get_node("GameOver")

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		print("GAME OVER durch: DeathZone (Spielfeldrand verlassen)")
		game_over.show()
		get_tree().paused = true
