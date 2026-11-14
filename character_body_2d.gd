extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -1000.0

# Feintuning für das Sprunggefühl
const FALL_GRAVITY_MULTIPLIER = 1.8      # Schnelleres, knackigeres Fallen
const LOW_JUMP_GRAVITY_MULTIPLIER = 3.0  # Bremst den Sprung stark ab, wenn "jump" losgelassen wird
const COYOTE_TIME = 0.1                  # 0.1 Sek. Toleranz nach Verlassen des Bodens
const JUMP_BUFFER_TIME = 0.1             # 0.1 Sek. Toleranz vor dem Landen

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var is_dead: bool = false

@onready var game_over = get_tree().current_scene.get_node("GameOver")

func _physics_process(delta: float) -> void:
	# 1. Coyote Time
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	# 2. Jump Buffer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer -= delta

	# 3. Sprung ausführen
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	# 4. Variable Schwerkraft
	if not is_on_floor():
		var gravity = get_gravity()
		if velocity.y > 0:
			velocity += gravity * FALL_GRAVITY_MULTIPLIER * delta
		elif velocity.y < 0 and not Input.is_action_pressed("jump"):
			velocity += gravity * LOW_JUMP_GRAVITY_MULTIPLIER * delta
		else:
			velocity += gravity * delta

	# 5. Links/Rechts-Bewegung
	var direction := Input.get_axis("left", "right")
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
	print("GAME OVER durch: ", reason, " | Spieler-Position: ", global_position)
	game_over.show()
	get_tree().paused = true
