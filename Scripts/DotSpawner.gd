extends Node

@export var dot_scene: PackedScene
# Initial time interval between spawns (in seconds).
@export var start_interval := 0.8
@export var min_interval := 0.025
# How quickly the spawn interval decreases over time.
# Higher accel means dots spawn faster as time progresses.
@export var accel := 0.02
# Base movement speed for spawned dots
@export var base_speed := 240.0
@export var speed_variance := 120.0

# Tracks how much time has passed since the game started.
var elapsed := 0.0
# The next time (in seconds) when a dot should spawn.
var next_time := 0.0
# Width of the screen, used to randomize spawn position along the x-axis.
var screen_w := 0.0

func _ready():
	# Called when the node enters the scene tree.
	screen_w = get_viewport().get_visible_rect().size.x
	# Store the width of the current viewport for positioning dots horizontally.
	print("Spawner ready, dot_scene:", dot_scene)

# Called every frame with the time since the last frame (delta).
func _process(delta):
	# If the game is paused, don't spawn anything.
	if get_tree().paused:
		return
	elapsed += delta
	# If it's time to spawn the next dot, spawn it.
	if elapsed >= next_time:
		_spawn_dot()
		# Schedule the next spawn time:
		# start_interval is reduced over time based on "accel"
		# Cap acceleration at 38 seconds, then maintain constant rate
		var accel_time = min(elapsed, 38.0)
		next_time = elapsed + max(min_interval, start_interval - accel_time * accel)

# Handles actually creating and adding a dot to the scene.
func _spawn_dot():
	if dot_scene == null:
		print("No dot_scene assigned!")
		return
	var dot = dot_scene.instantiate()
	# Place the dot at a random x-position within the screen width.
	# The y-position is -20 so it starts just above the visible screen.
	dot.global_position = Vector2(randf() * screen_w, -20)
	print("Spawned dot at ", dot.global_position)
	# Add the dot to the current scene so it becomes active.
	get_tree().current_scene.add_child(dot)
