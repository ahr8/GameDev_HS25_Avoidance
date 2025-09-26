extends Node2D

@onready var ui := $UI
var over := false

func _ready():
	add_to_group("game")
	# keep processing input while paused
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func on_player_hit():
	if over: return
	over = true
	get_tree().paused = true
	ui.call("show_game_over")

func _process(_delta):
	if over and Input.is_action_just_pressed("restart"):
		get_tree().paused = false
		get_tree().reload_current_scene()
