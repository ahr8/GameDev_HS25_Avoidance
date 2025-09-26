extends CharacterBody2D

@export var speed := 420.0
var screen_size := Vector2.ZERO

func _ready():
	add_to_group("player")
	screen_size = get_viewport().get_visible_rect().size
	global_position = Vector2(screen_size.x * 0.5, screen_size.y - 60)
	print("Player ready at ", global_position)

func _physics_process(_delta):
	var x := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if Engine.get_frames_drawn() % 30 == 0:
		print("Input x:", x)
	velocity = Vector2(x * speed, 0)
	move_and_slide()
	global_position.x = clamp(global_position.x, 24.0, screen_size.x - 24.0)
