extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -1000.0

const FALL_GRAVITY_MULTIPLIER = 1.8
const LOW_JUMP_GRAVITY_MULTIPLIER = 3.0
const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.1

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var is_dead: bool = false

@onready var game_over = get_tree().current_scene.get_node("GameOver")

func _ready() -> void:
	if GameSettings.player_count == 1:
		queue_free()
		return

	show()
	add_to_group("players")

func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump_p2"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer -= delta

	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	if not is_on_floor():
		var gravity = get_gravity()
		if velocity.y > 0:
			velocity += gravity * FALL_GRAVITY_MULTIPLIER * delta
		elif velocity.y < 0 and not Input.is_action_pressed("jump_p2"):
			velocity += gravity * LOW_JUMP_GRAVITY_MULTIPLIER * delta
		else:
			velocity += gravity * delta

	var direction := Input.get_axis("left_p2", "right_p2")
	if direction:
		velocity.x = direction * SPEED
	else:
		var friction = 4000.0 if is_on_floor() else 1200.0
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()

func die(reason: String = "Unbekannt") -> void:
	if is_dead:
		return
	is_dead = true

	var winner_label = game_over.find_child("WinnerLabel", true, false)
	if winner_label != null:
		winner_label.text = "Spieler 1 hat gewonnen!"
		winner_label.show()

	game_over.show()
	get_tree().paused = true
