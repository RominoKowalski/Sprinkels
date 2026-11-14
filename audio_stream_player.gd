extends Node

var player: AudioStreamPlayer

func _ready() -> void:
	# Läuft auch während Game Over (Pause) weiter
	process_mode = Node.PROCESS_MODE_ALWAYS

	player = AudioStreamPlayer.new()
	player.stream = load("res://game_music.mp3")
	player.volume_db = -10.0 # Lautstärke in Dezibel (0 = normal, -10 = etwas leiser)
	add_child(player)
	player.play()
