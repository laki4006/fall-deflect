extends RigidBody2D

signal died

const RADIUS := 22.0

func _ready() -> void:
	add_to_group("player")
	body_entered.connect(_on_body_entered)

func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS, Color(0.25, 0.65, 1.0))

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("hazard"):
		die()
	elif body.is_in_group("platform"):
		body.consume()

func die() -> void:
	$DeathSound.play()
	died.emit()
