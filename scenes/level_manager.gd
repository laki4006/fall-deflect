extends Node2D

const SPIKE_SCENE := preload("res://scenes/spike.tscn")
const GOAL_SCENE := preload("res://scenes/goal.tscn")

var levels := [
	{
		"start_position": Vector2(0, -400),
		"spikes": [Vector2(0, 900)],
		"max_platforms": 1,
		"max_width": 260.0,
		"goal_position": Vector2(0, 1400),
	},
	{
		"start_position": Vector2(0, -400),
		"spikes": [Vector2(-120, 850), Vector2(140, 1150)],
		"max_platforms": 1,
		"max_width": 220.0,
		"goal_position": Vector2(100, 1700),
	},
	{
		"start_position": Vector2(0, -400),
		"spikes": [Vector2(-150, 750), Vector2(120, 1000), Vector2(-80, 1300), Vector2(160, 1550)],
		"max_platforms": 2,
		"max_width": 200.0,
		"goal_position": Vector2(-100, 2000),
	},
]

@onready var player: RigidBody2D = get_tree().get_first_node_in_group("player")
@onready var spikes_container: Node2D = $"../SpikesContainer"

func _ready() -> void:
	var index: int = clampi(GameState.current_level, 0, levels.size() - 1)
	var data: Dictionary = levels[index]

	for pos in data["spikes"]:
		var spike := SPIKE_SCENE.instantiate()
		spike.position = pos
		spikes_container.add_child(spike)

	var goal := GOAL_SCENE.instantiate()
	goal.position = data["goal_position"]
	add_child(goal)

	var game_manager := get_tree().get_first_node_in_group("game_manager")
	goal.reached.connect(game_manager._on_goal_reached)

	player.global_position = data["start_position"]

	var draw_controller := get_tree().get_first_node_in_group("draw_controller")
	draw_controller.max_platforms = data["max_platforms"]
	draw_controller.max_width = data["max_width"]
