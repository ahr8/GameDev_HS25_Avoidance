extends CanvasLayer

var t := 0.0
var last_displayed_time := 0.0
@onready var time_label: Label = $TimeLabel
@onready var best_label: Label = $BestLabel
@onready var panel: Control = $GameOver
@onready var game_over_label: Label = $GameOver/Label

func _ready():
	# Ensure Game Over UI starts hidden
	panel.visible = false
	game_over_label.visible = false

func _process(delta):
	if get_tree().paused:
		return
	t += delta
	# Only update display when time changes significantly (every 0.1 seconds)
	if t - last_displayed_time >= 0.1:
		time_label.text = "Time: %.2f" % t
		best_label.text = "Best: %.2f" % GameState.best_time
		last_displayed_time = t

func get_current_time() -> float:
	"""Get the current game time"""
	return t

func show_game_over():
	# Update the global best
	GameState.best_time = max(GameState.best_time, t)
	panel.visible = true
	# Force-toggle the label to match panel visibility
	game_over_label.visible = true
	# Refresh the labels immediately so they show the new best even if paused
	time_label.text = "Time: %.2f" % t
	best_label.text = "Best: %.2f" % GameState.best_time
