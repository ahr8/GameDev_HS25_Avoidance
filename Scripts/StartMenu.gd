extends Control

@onready var single_player_button = $LeftPanel/StartOneButton
@onready var two_player_button = $LeftPanel/StartTwoButton
@onready var single_player_score = $RightPanel/SingleScoreLabel
@onready var two_player_score = $RightPanel/TwoScoreLabel
@onready var single_overlay: Control = $SinglePlayerOverlay
@onready var two_overlay: Control = $TwoPlayerOverlay
@onready var overlay_timer: Timer = $OverlayTimer
@onready var single_controls_tex: TextureRect = $SinglePlayerOverlay/ControlsTexture1
@onready var two_controls_tex_1: TextureRect = $TwoPlayerOverlay/ControlsTexture1
@onready var two_controls_tex_2: TextureRect = $TwoPlayerOverlay/ControlsTexture2

@export var controls_single_texture: Texture2D
@export var controls_wasd_texture: Texture2D


func _ready():
	# Connect button signals
	single_player_button.pressed.connect(_on_single_player_pressed)
	two_player_button.pressed.connect(_on_two_player_pressed)
	
	# Update high score displays
	update_high_score_displays()


func update_high_score_displays():
	"""Update the high score labels with current values"""
	# Access HighScoreManager through get_node
	var high_score_manager = get_node("/root/HighScoreManager")
	if high_score_manager == null:
		single_player_score.text = "Single Ship score: 0.00s"
		two_player_score.text = "Two Ship score: 0.00s"
		return
		
	var single_score = high_score_manager.get_high_score("single")
	var two_score = high_score_manager.get_high_score("two")
	
	single_player_score.text = "Single Ship score:\n%.2fs" % single_score
	two_player_score.text = "Two Ship score:\n%.2fs" % two_score

func _on_single_player_pressed():
	"""Start single player game"""
	GameState.game_mode = "single"
	_show_controls_then_start()

func _on_two_player_pressed():
	"""Start two player game"""
	GameState.game_mode = "two"
	_show_controls_then_start()

func _show_controls_then_start():
	# Hide main menu elements
	$LeftPanel.visible = false
	$RightPanel.visible = false
	$Title.visible = false
	
	if GameState.game_mode == "single":
		# Show single player overlay
		if controls_single_texture != null:
			single_controls_tex.texture = controls_single_texture
		single_overlay.visible = true
		two_overlay.visible = false
	else:
		# Show two player overlay
		if controls_single_texture != null:
			two_controls_tex_1.texture = controls_single_texture
		if controls_wasd_texture != null:
			two_controls_tex_2.texture = controls_wasd_texture
		single_overlay.visible = false
		two_overlay.visible = true
	
	overlay_timer.timeout.connect(_start_game)
	overlay_timer.start()

func _start_game():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
