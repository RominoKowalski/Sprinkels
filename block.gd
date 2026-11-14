extends CharacterBody2D

@export var min_speed: float = 400.0
@export var max_speed: float = 750.0
@export var speed_increase_per_second: float = 5.0
@export var distance: float = 2000.0

@export var min_height_offset: float = -150.0 # Maximal 150px höher
@export var max_height_offset: float = 50.0   # Maximal 50px tiefer

var speed_bonus: float = 0.0
var current_speed: float = 0.0
var start_position: Vector2
var waiting: bool = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	start_position = global_position
	anim.play("default")
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

	var wait_time = randf_range(1.0, 5.0)
	await get_tree().create_timer(wait_time, false).timeout

	current_speed = randf_range(min_speed, max_speed)

	var random_y = randf_range(min_height_offset, max_height_offset)
	global_position.y = start_position.y + random_y

	show()
	anim.play("default")
	waiting = false
