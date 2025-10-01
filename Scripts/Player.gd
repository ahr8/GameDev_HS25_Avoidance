extends CharacterBody2D

@export var speed := 420.0
var screen_size := Vector2.ZERO
@export var vertical_nudge := 60.0
@export var effect_duration := 3.0
@export var effect_cooldown := 3.0
@export var acceleration := 1600.0
@export var deceleration := 2000.0
@export var nudge_max_speed := 600.0
@export var nudge_acceleration := 2400.0
@export var nudge_spring_stiffness := 120.0
@export var nudge_spring_damping := 14.0
@export var y_margin := 24.0
@export var start_at_bottom := true
@export var start_x_fraction := 0.5
@export var move_left_action := "ui_left"
@export var move_right_action := "ui_right"
@export var effect_up_action := "ui_up"
@export var effect_down_action := "ui_down"

var effect_active := false
var effect_timer := 0.0
var cooldown_timer := 0.0
var effect_direction := 0 # 1 for up (faster), -1 for down (slower)
var base_y := 0.0
var nudge_velocity := 0.0




func _ready():
	add_to_group("player")
	screen_size = get_viewport().get_visible_rect().size
	global_position = Vector2(screen_size.x * start_x_fraction, (screen_size.y - 60.0) if start_at_bottom else 60.0)
	base_y = global_position.y
	print("Player ready at ", global_position)

func _physics_process(delta):
	# Horizontal movement
	var x := Input.get_action_strength(move_right_action) - Input.get_action_strength(move_left_action)
	var target_speed := x * speed
	if x != 0.0:
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)

	# Handle effect timers
	if cooldown_timer > 0.0:
		cooldown_timer -= delta
		if cooldown_timer < 0.0:
			cooldown_timer = 0.0

	if effect_active:
		effect_timer -= delta
		if effect_timer <= 0.0:
			_end_effect()

	# Start effects on press if available
	if not effect_active and cooldown_timer == 0.0:
		if Input.is_action_just_pressed(effect_up_action):
			_start_effect(1)
		elif Input.is_action_just_pressed(effect_down_action):
			_start_effect(-1)

	# Early end on release
	if effect_active:
		if (effect_direction == 1 and Input.is_action_just_released(effect_up_action)) or (effect_direction == -1 and Input.is_action_just_released(effect_down_action)):
			_end_effect()

	move_and_slide()
	global_position.x = clamp(global_position.x, 24.0, screen_size.x - 24.0)
	# Elastic nudge using spring-damper for overshoot and sling back on release
	var target_y := base_y - (vertical_nudge * float(effect_direction) if effect_active else 0.0)
	# Clamp target within screen bounds
	target_y = clamp(target_y, y_margin, screen_size.y - y_margin)
	var displacement := global_position.y - target_y
	var accel_y := -nudge_spring_stiffness * displacement - nudge_spring_damping * nudge_velocity
	nudge_velocity += accel_y * delta
	# Cap nudge velocity to keep motion controlled
	nudge_velocity = clamp(nudge_velocity, -nudge_max_speed, nudge_max_speed)
	global_position.y += nudge_velocity * delta
	# Ensure final position stays in bounds
	global_position.y = clamp(global_position.y, y_margin, screen_size.y - y_margin)
	
	# --- Handle animations ---
	if x < 0:
		$AnimatedSprite2D.animation = "left"
	elif x > 0:
		$AnimatedSprite2D.animation = "right"
	elif effect_active and effect_direction == 1:
		$AnimatedSprite2D.animation = "boost"
	else:
		$AnimatedSprite2D.animation = "idle"

func _start_effect(dir: int) -> void:
	effect_active = true
	effect_direction = dir
	effect_timer = effect_duration
	GameState.dot_speed_multiplier = 1.6 if dir == 1 else 0.6

func _end_effect() -> void:
	effect_active = false
	effect_timer = 0.0
	cooldown_timer = effect_cooldown
	effect_direction = 0
	GameState.dot_speed_multiplier = 1.0
