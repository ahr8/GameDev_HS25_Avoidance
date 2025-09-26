extends Area2D

@export var fall_speed: float = 260.0
@export var radius: float = 10.0
@export var color: Color = Color(1, 0.2, 0.3)
var screen_h: float

func _ready():
	screen_h = get_viewport().get_visible_rect().size.y   
	queue_redraw()

func _process(delta):
	global_position.y += fall_speed * delta
	if global_position.y > screen_h + radius + 10.0:
		queue_free()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		get_tree().call_group("game", "on_player_hit")
