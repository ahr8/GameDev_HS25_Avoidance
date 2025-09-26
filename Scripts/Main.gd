extends Node2D

@onready var ui := $UI
var over := false

func _ready():
	add_to_group("game")
	# keep processing input while paused
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_ensure_wasd_actions()

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

func on_player_hit():
	if over: return
	over = true
	get_tree().paused = true
	ui.call("show_game_over")

func _process(_delta):
	if over and Input.is_action_just_pressed("restart"):
		get_tree().paused = false
		get_tree().reload_current_scene()
