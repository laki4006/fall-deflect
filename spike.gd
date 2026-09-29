extends StaticBody2D

var points := PackedVector2Array([Vector2(-26, 20), Vector2(26, 20), Vector2(0, -26)])

func _ready() -> void:
	$CollisionPolygon2D.polygon = points
	add_to_group("hazard")

func _draw() -> void:
	draw_colored_polygon(points, Color(0.9, 0.2, 0.25))
