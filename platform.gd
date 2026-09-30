extends StaticBody2D

var length := 200.0
var thickness := 14.0
var consumed := false

func _ready() -> void:
	var rect := RectangleShape2D.new()
	rect.size = Vector2(length, thickness)
	$CollisionShape2D.shape = rect
	add_to_group("platform")

func _draw() -> void:
	draw_rect(Rect2(-length / 2.0, -thickness / 2.0, length, thickness), Color(1.0, 0.85, 0.2))

func consume() -> void:
	if consumed:
		return
	consumed = true

	collision_layer = 0
	collision_mask = 0

	_detach_sound()

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.15)
	tween.tween_callback(queue_free)

func _detach_sound() -> void:
	var sound: AudioStreamPlayer2D = $BounceSound
	var sound_pos := sound.global_position
	remove_child(sound)
	get_tree().current_scene.add_child(sound)
	sound.global_position = sound_pos
	sound.play()
	sound.finished.connect(sound.queue_free)
