extends Line2D

@export var max_points := 30
@export var point_spacing := 4.0

@onready var player: RigidBody2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	width = 30.0
	texture_mode = Line2D.LINE_TEXTURE_NONE
	joint_mode = Line2D.LINE_JOINT_ROUND
	begin_cap_mode = Line2D.LINE_CAP_ROUND
	end_cap_mode = Line2D.LINE_CAP_ROUND
	gradient = _build_gradient()

func _build_gradient() -> Gradient:
	var g := Gradient.new()
	g.colors = PackedColorArray([
		Color(0.3, 0.7, 1.0, 0.0),
		Color(0.3, 0.7, 1.0, 0.6),
	])
	g.offsets = PackedFloat32Array([0.0, 1.0])
	return g

func _process(_delta: float) -> void:
	if player == null:
		return
	if get_point_count() == 0 or player.global_position.distance_to(get_point_position(get_point_count() - 1)) >= point_spacing:
		add_point(player.global_position)
		if get_point_count() > max_points:
			remove_point(0)
