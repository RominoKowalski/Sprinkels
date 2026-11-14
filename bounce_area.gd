extends Area2D

@export var bounce_up_force: float = -1200.0
@export var bounce_side_force: float = 600.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not get_parent().visible:
		return

	if body.is_in_group("players"):
		body.velocity.y = bounce_up_force
		if body.global_position.x < global_position.x:
			body.velocity.x = -bounce_side_force
		else:
			body.velocity.x = bounce_side_force
