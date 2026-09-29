extends StaticBody2D

var length := 200.0
var thickness := 14.0

func _ready() -> void:
	var rect := RectangleShape2D.new()
	rect.size = Vector2(length, thickness)
	$CollisionShape2D.shape = rect
	add_to_group("platform")

func _draw() -> void:
	draw_rect(Rect2(-length / 2.0, -thickness / 2.0, length, thickness), Color(1.0, 0.85, 0.2))

func consume() -> void:
	queue_free()
