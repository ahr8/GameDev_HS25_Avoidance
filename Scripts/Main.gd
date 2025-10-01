extends Node2D

@onready var ui := $UI
var over := false

func _ready():
	add_to_group("game")
	# keep processing input while paused
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_ensure_wasd_actions()
	_configure_players()

func _ensure_wasd_actions() -> void:
	var mapping := {
		"move_left": KEY_A,
		"move_right": KEY_D,
		"move_up": KEY_W,
		"move_down": KEY_S,
	}
	for action in mapping.keys():
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			print("Added input action: ", action)
		# Check if this physical key is already mapped
		var exists := false
		for ev in InputMap.action_get_events(action):
			if ev is InputEventKey and ev.physical_keycode == mapping[action]:
				exists = true
				break
		if not exists:
			var e := InputEventKey.new()
			e.physical_keycode = mapping[action]
			InputMap.action_add_event(action, e)
			print("Added key mapping for ", action, " to key ", mapping[action])
		else:
			print("Key mapping already exists for ", action)

func _configure_players():
	"""Configure players based on game mode"""
	print("Configuring players for mode: ", GameState.game_mode)
	if GameState.game_mode == "single":
		# Hide second player for single player mode
		$Player2.visible = false
		$Player2.process_mode = Node.PROCESS_MODE_DISABLED
		print("Single player mode: Player2 disabled, Player1 uses default settings")
	else:
		# Show both players for two player mode
		$Player.visible = true
		$Player2.visible = true
		$Player.process_mode = Node.PROCESS_MODE_ALWAYS
		$Player2.process_mode = Node.PROCESS_MODE_ALWAYS
		print("Two player mode: Both players enabled")
		print("Player1 input actions: ", $Player.move_left_action, $Player.move_right_action, $Player.effect_up_action, $Player.effect_down_action)
		print("Player2 input actions: ", $Player2.move_left_action, $Player2.move_right_action, $Player2.effect_up_action, $Player2.effect_down_action)
		print("Player1 visible: ", $Player.visible, " process_mode: ", $Player.process_mode)
		print("Player2 visible: ", $Player2.visible, " process_mode: ", $Player2.process_mode)

func on_player_hit():
	if over: return
	over = true
	get_tree().paused = true
	
	# Update high score
	var current_time = ui.get_current_time()
	HighScoreManager.update_high_score(GameState.game_mode, current_time)
	
	ui.call("show_game_over")
	# Wait a moment then go back to start menu
	await get_tree().create_timer(2.0).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")


