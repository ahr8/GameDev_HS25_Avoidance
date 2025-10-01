extends Node

# High score storage using a ConfigFile at user://highscores.cfg
const CONFIG_PATH := "user://highscores.cfg"
const SECTION := "highscores"
const SINGLE_PLAYER_KEY := "single"
const TWO_PLAYER_KEY := "two"

var single_player_high_score: float = 0.0
var two_player_high_score: float = 0.0

func _ready():
	load_high_scores()

func load_high_scores() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load(CONFIG_PATH)
	if err == OK:
		single_player_high_score = float(cfg.get_value(SECTION, SINGLE_PLAYER_KEY, 0.0))
		two_player_high_score = float(cfg.get_value(SECTION, TWO_PLAYER_KEY, 0.0))
	else:
		# No file yet; start from defaults
		single_player_high_score = 0.0
		two_player_high_score = 0.0

func save_high_scores() -> void:
	var cfg := ConfigFile.new()
	# Write values
	cfg.set_value(SECTION, SINGLE_PLAYER_KEY, single_player_high_score)
	cfg.set_value(SECTION, TWO_PLAYER_KEY, two_player_high_score)
	# Persist to disk
	cfg.save(CONFIG_PATH)

func update_high_score(game_mode: String, score: float) -> void:
	match game_mode:
		"single":
			if score > single_player_high_score:
				single_player_high_score = score
				save_high_scores()
		"two":
			if score > two_player_high_score:
				two_player_high_score = score
				save_high_scores()

func get_high_score(game_mode: String) -> float:
	match game_mode:
		"single":
			return single_player_high_score
		"two":
			return two_player_high_score
		_:
			return 0.0
