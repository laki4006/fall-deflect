extends Node

signal game_over
signal level_complete

@onready var player: RigidBody2D = get_tree().get_first_node_in_group("player")
@onready var game_over_panel: Panel = $"../UI/GameOverPanel"
@onready var level_complete_panel: Panel = $"../UI/LevelCompletePanel"

var is_round_over := false

func _ready() -> void:
	add_to_group("game_manager")
	player.died.connect(_on_player_died)
	$"../UI/GameOverPanel/RestartButton".pressed.connect(_on_restart_pressed)
	$"../UI/LevelCompletePanel/NextButton".pressed.connect(_on_next_pressed)

func _on_goal_reached() -> void:
	if is_round_over:
		return
	is_round_over = true
	level_complete_panel.show()
	get_tree().paused = true

func _on_player_died() -> void:
	if is_round_over:
		return
	is_round_over = true
	game_over_panel.show()
	get_tree().paused = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_next_pressed() -> void:
	get_tree().paused = false
	GameState.current_level += 1
	get_tree().reload_current_scene()
