extends Area2D

@export var current_held = 0
var grabbing = false
var grab_dir = Vector2.ZERO

func grab(dir):
	grab_dir = dir
	grabbing = true
	rotation = grab_dir.angle()	
	$GrabTimer.start()

func ungrab():
	current_held = 0
	$AnimatedSprite2D.play("default")

func _process(delta):
	if $GrabTimer.get_time_left() > 0 && current_held == 0:
		position += grab_dir.normalized() * 800 * delta
	elif (position.x < 64 || position.x > 66) || (position.y < 26 || position.y > 28):
		position += (Vector2(65, 27) - position).normalized() * 800 * delta
	else:
		if grabbing:
			grabbing = false
			rotation = 0
		

func _on_body_entered(body):
	if grabbing:
		match body.name:
			"Bombclock":
				current_held = 1
				$AnimatedSprite2D.play("bombclock")
			"Wheelcharger":
				current_held = 2
				$AnimatedSprite2D.play("wheelcharger")
			"Rumbee":
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
