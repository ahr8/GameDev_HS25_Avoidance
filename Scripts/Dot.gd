extends Area2D

@export var fall_speed: float = 260.0
@export var radius: float = 10.0
@export var color: Color = Color(1, 0.8, 0.3) # golden/yellow star
var screen_h: float
var rotation_angle: float = 0.0
var twinkle_speed: float = randf_range(2.0, 5.0)

func _ready():
	screen_h = get_viewport().get_visible_rect().size.y   
	queue_redraw()

func _process(delta):
	global_position.y += fall_speed * GameState.dot_speed_multiplier * delta
	if global_position.y > screen_h + radius + 10.0:
		queue_free()

	# Twinkle effect (size oscillates)
	radius = 6.0 + sin(Time.get_ticks_msec() / 1000.0 * twinkle_speed) * 2.0
	# Rotate the star
	rotation_angle += delta * 2.0
	queue_redraw()

func _draw():
	# Base star points
	var points = [
		Vector2(0, -radius),
		Vector2(radius * 0.4, -radius * 0.4),
		Vector2(radius, 0),
		Vector2(radius * 0.4, radius * 0.4),
		Vector2(0, radius),
		Vector2(-radius * 0.4, radius * 0.4),
		Vector2(-radius, 0),
		Vector2(-radius * 0.4, -radius * 0.4)
	]

	# Rotate all points around center
	var rotated_points: Array = []
	for p in points:
		rotated_points.append(p.rotated(rotation_angle))

	draw_colored_polygon(rotated_points, color)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		get_tree().call_group("game", "on_player_hit")
