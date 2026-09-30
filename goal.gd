extends Area2D

signal reached

const SIZE := 60.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _draw() -> void:
	draw_rect(Rect2(-SIZE / 2.0, -SIZE / 2.0, SIZE, SIZE), Color(0.2, 0.9, 0.3))

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		$WinSound.play()
		reached.emit()
