extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		# Ruft direkt die die()-Funktion vom Spieler auf
		if body.has_method("die"):
			body.die("DeathZone (" + name + ")")
		else:
			print("GAME OVER durch: ", name)
			get_tree().current_scene.get_node("GameOver").show()
			get_tree().paused = true
