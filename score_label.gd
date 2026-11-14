extends Label

var score: float = 0.0
@export var points_per_second: float = 100.0

var highscore: int = 0
var highscore_name: String = "Niemand"
const SAVE_PATH = "user://highscore.cfg"

@onready var highscore_label: Label = get_parent().get_node("HighscoreLabel")
@onready var name_input: LineEdit = get_tree().current_scene.get_node("GameOver/ColorRect/NameInput")

func _ready() -> void:
	if GameSettings.player_count == 2:
		# Im 2-Spieler-Modus keinen Highscore anzeigen oder speichern
		highscore_label.hide()
		name_input.hide()
		text = "2-Player Modus"
		return

	highscore_label.show()
	name_input.show()
	load_highscore()
	update_highscore_display()
	name_input.text_changed.connect(_on_name_changed)

func _process(delta: float) -> void:
	# Im 2-Spieler-Modus läuft kein Highscore-Zähler
	if GameSettings.player_count == 2:
		return

	if not get_tree().paused:
		score += points_per_second * delta
		var current_score := int(score)
		text = "Score: " + str(current_score)

		if current_score > highscore:
			highscore = current_score
			if name_input.text.strip_edges() != "":
				highscore_name = name_input.text.strip_edges()
			save_highscore()
			update_highscore_display()

func _on_name_changed(new_text: String) -> void:
	if GameSettings.player_count == 2:
		return
	if int(score) >= highscore:
		var clean_name = new_text.strip_edges()
		highscore_name = clean_name if clean_name != "" else "Spieler"
		save_highscore()
		update_highscore_display()

func update_highscore_display() -> void:
	highscore_label.text = "Highscore: " + str(highscore) + " (" + highscore_name + ")"

func save_highscore() -> void:
	var config = ConfigFile.new()
	config.set_value("records", "highscore", highscore)
	config.set_value("records", "name", highscore_name)
	config.save(SAVE_PATH)

func load_highscore() -> void:
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		highscore = config.get_value("records", "highscore", 0)
		highscore_name = config.get_value("records", "name", "Niemand")
		if highscore_name != "Niemand":
			name_input.text = highscore_name
