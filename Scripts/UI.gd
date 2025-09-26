extends CanvasLayer

var t := 0.0
@onready var timer_label: Label = $TimerLabel
@onready var panel: Control = $GameOver

func _process(delta):
	if get_tree().paused:
		return
	t += delta
	# Read best from the singleton so it persists across scene reloads
	timer_label.text = "Time: %.2f  Best: %.2f" % [t, GameState.best_time]

func show_game_over():
	# Update the global best
	GameState.best_time = max(GameState.best_time, t)
	panel.visible = true
	# Refresh the label immediately so it shows the new best even if paused
	timer_label.text = "Time: %.2f  Best: %.2f" % [t, GameState.best_time]
