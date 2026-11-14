extends AnimatedSprite2D

@onready var player: CharacterBody2D = get_parent()

func _process(_delta: float) -> void:
	if player == null:
		return

	if not player.is_on_floor():
		if player.velocity.x < 0:
			play("jump-left")
		elif player.velocity.x > 0:
			play("jump-right")
		else:
			play("jump")
	elif player.velocity.x < 0:
		play("left")
	elif player.velocity.x > 0:
		play("right")
	else:
		play("default")
