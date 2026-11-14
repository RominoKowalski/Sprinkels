extends CharacterBody2D

@export var min_speed: float = 350.0
@export var max_speed: float = 650.0
@export var speed_increase_per_second: float = 5.0
@export var distance: float = 2000.0

# Höhen-Bereich (relativ zur platzierten Position im Editor)
@export var min_height_offset: float = -150.0
@export var max_height_offset: float = 50.0

var speed_bonus: float = 0.0
var current_speed: float = 0.0
var start_position: Vector2
var waiting: bool = false

func _ready() -> void:
	start_position = global_position
	# Falls du ein AnimatedSprite2D im Slime-Block hast, wird es hier gestartet:
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("default")
	respawn_after_delay()

func _physics_process(delta: float) -> void:
	speed_bonus += speed_increase_per_second * delta

	if waiting:
		return

	global_position.x -= (current_speed + speed_bonus) * delta

	if global_position.x <= start_position.x - distance:
		respawn_after_delay()

func respawn_after_delay() -> void:
	waiting = true
	hide()
	global_position.x = start_position.x

	# Zufällige Wartezeit zwischen 2.0 und 6.0 Sekunden
	var wait_time = randf_range(2.0, 6.0)
	await get_tree().create_timer(wait_time, false).timeout

	current_speed = randf_range(min_speed, max_speed)

	var random_y = randf_range(min_height_offset, max_height_offset)
	global_position.y = start_position.y + random_y

	show()
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("default")
	waiting = false
