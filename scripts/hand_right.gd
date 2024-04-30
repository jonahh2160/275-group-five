extends Area2D

var punch_dir = Vector2.ZERO
var punching = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $PunchTimer.get_time_left() > 0:
		position += punch_dir.normalized() * 800 * delta
	elif (position.x < -64 || position.x > -66) || (position.y < 26 || position.y > 28):
		position += (Vector2(-65, 27) - position).normalized() * 800 * delta

func punch(dir):
	punch_dir = dir
	rotation = punch_dir.angle()
	punching = true
	$PunchTimer.start()

func _on_body_entered(body):
	if punching:
		body.queue_free()
