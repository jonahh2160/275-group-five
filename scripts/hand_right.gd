extends Area2D

var punch_dir = Vector2.ZERO
var punching = false
var has_punched = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $PunchTimer.get_time_left() > 0 and punching and !has_punched:
		position += punch_dir.normalized() * 800 * delta
	elif (position.x > -63 || position.x < -67) || (position.y < 25 || position.y > 29):
		position += (Vector2(-65, 27) - position).normalized() * 800 * delta
	else:
		if punching:
			punching = false
			has_punched = false
			$AnimatedSprite2D.play("default")
		if rotation_degrees != -30:
			rotation_degrees = -30

func punch(dir):
	punch_dir = dir
	rotation = punch_dir.angle() + PI
	punching = true
	$AnimatedSprite2D.play("punch")
	$PunchTimer.start()

func _on_body_entered(body):
	if punching and !has_punched:
		body.queue_free()
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.75, 2)
		$AudioStreamPlayer2D.play()
		has_punched = true
