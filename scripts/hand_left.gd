extends Area2D

signal enemy_grabbed
signal enemy_discarded

var current_held = 0
var grabbing = false
var has_grabbed = false
var grab_dir = Vector2.ZERO
var swiping = false

func grab(dir):
	grab_dir = dir
	grabbing = true
	rotation = grab_dir.angle()	
	$GrabTimer.start()

func ungrab():
	if not grabbing:
		current_held = 0
		enemy_discarded.emit()
		$AnimatedSprite2D.play("default")

func _process(delta):
	if $GrabTimer.get_time_left() > 0 && current_held == 0 && !has_grabbed:
		position += grab_dir.normalized() * 800 * delta
	elif swiping:
		pass
	elif (position.x < 63 || position.x > 67) || (position.y < 25 || position.y > 29):
		position += (Vector2(65, 27) - position).normalized() * 800 * delta
	else:
		if grabbing :
			grabbing = false
			has_grabbed = false
		if rotation_degrees != 30:
			rotation_degrees = 30
		

func _on_body_entered(body):
	if grabbing && current_held == 0 && !has_grabbed:
		match body.score_value:
			# Bombclock
			15:
				current_held = 1
				$AnimatedSprite2D.play("bombclock")
			# Wheelcharger
			20:
				current_held = 2
				$AnimatedSprite2D.play("wheelcharger")
			# Gumbyrumbee
			10:
				current_held = 3
				match body.color:
					"red_gumby":
						$AnimatedSprite2D.play("gumby_red")
					"orange_gumby":
						$AnimatedSprite2D.play("gumby_tan")
					"gray_gumby":
						$AnimatedSprite2D.play("gumby_gray")
					"green_gumby":
						$AnimatedSprite2D.play("gumby_green")
		body.queue_free()
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.75, 2)
		$AudioStreamPlayer2D.play()
		enemy_grabbed.emit()
		has_grabbed = true

func rumbee_swipe():
	swiping = true
