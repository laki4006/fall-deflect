extends Node2D

const PLATFORM_SCENE := preload("res://scenes/platform.tscn")
const PLATFORM_THICKNESS := 14.0

@export var max_platforms := 1
@export var max_width := 260.0
@export var min_length := 20.0
@export var max_draw_time := 5.0

@onready var timer_bar: ProgressBar = $TimerLayer/TimerBar

var is_drawing := false
var is_blocked := false
var start_point := Vector2.ZERO
var end_point := Vector2.ZERO
var time_left := 0.0

func _ready() -> void:
	add_to_group("draw_controller")
	timer_bar.max_value = max_draw_time
	timer_bar.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start_drawing()
		else:
			stop_drawing()

func _process(delta: float) -> void:
	if not is_drawing:
		return
	var mouse := get_global_mouse_position()
	end_point = start_point + (mouse - start_point).limit_length(max_width)
	is_blocked = line_touches_ball()
	time_left -= delta
	timer_bar.value = time_left
	queue_redraw()
	if time_left <= 0.0:
		stop_drawing()

func line_touches_ball() -> bool:
	var ball := get_tree().get_first_node_in_group("player")
	if ball == null:
		return false
	var closest := Geometry2D.get_closest_point_to_segment(ball.global_position, start_point, end_point)
	var reach: float = ball.RADIUS + PLATFORM_THICKNESS / 2.0
	return ball.global_position.distance_to(closest) < reach

func start_drawing() -> void:
	var game_manager := get_tree().get_first_node_in_group("game_manager")
	if game_manager and game_manager.is_round_over:
		return
	if get_tree().get_nodes_in_group("platform").size() >= max_platforms:
		return
	is_drawing = true
	is_blocked = false
	start_point = get_global_mouse_position()
	end_point = start_point
	time_left = max_draw_time
	timer_bar.value = time_left
	timer_bar.show()
	get_tree().paused = true

func stop_drawing() -> void:
	if not is_drawing:
		return
	is_drawing = false
	timer_bar.hide()
	if not is_blocked and start_point.distance_to(end_point) >= min_length:
		spawn_platform()
	get_tree().paused = false
	queue_redraw()

func spawn_platform() -> void:
	var platform := PLATFORM_SCENE.instantiate()
	platform.length = start_point.distance_to(end_point)
	platform.position = (start_point + end_point) / 2.0
	platform.rotation = (end_point - start_point).angle()
	get_parent().add_child(platform)

func _draw() -> void:
	if is_drawing:
		var color := Color(1.0, 0.5, 0.2, 0.8)
		if is_blocked:
			color = Color(1.0, 0.15, 0.15, 0.9)
		draw_line(start_point, end_point, color, PLATFORM_THICKNESS)
