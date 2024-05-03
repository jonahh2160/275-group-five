extends Area2D

signal enemy_grabbed
signal enemy_discarded

@onready var player = get_node("/root/main/Player")

var current_held = 0
var grabbing = false
var has_grabbed = false
var grab_dir = Vector2.ZERO
var swiping = false
var time = 0.0

func grab(dir):
	grab_dir = dir
	grabbing = true
	rotation = grab_dir.angle()	
	$GrabTimer.start()

func ungrab():
	if !grabbing || swiping:
		has_grabbed = false
		current_held = 0
		enemy_discarded.emit()
		$AnimatedSprite2D.play("default")
	else:
		position = Vector2(65, 27)

func _process(delta):
	if $GrabTimer.get_time_left() > 0 && current_held == 0 && !has_grabbed:
		position += grab_dir.normalized() * 800 * delta
	elif swiping:
		rumbee_swipe(delta)
	elif (position.x < 60 || position.x > 70) || (position.y < 25 || position.y > 29):
		position += (Vector2(65, 27) - position).normalized() * 800 * delta
	else:
		if grabbing :
			grabbing = false
			has_grabbed = false
		if rotation_degrees != 30:
			rotation_degrees = 30
		if position != Vector2(65, 27):
			position = Vector2(65, 27)
		

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
	elif swiping:
		body.queue_free()
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.75, 2)
		$AudioStreamPlayer2D.play()

func rumbee_swipe(delta):
	if not $SwipeTimer.is_stopped():
		# Thanks to golddotaskquestions on Reddit
		time += delta
		var angle = 7 * time
		var rotation = Vector2(cos(angle), sin(angle))
		position = rotation * 250
	else:
		swiping = true
		
		# Get a direction at all costs
		grab_dir = player.get_dir_aim()
		if grab_dir == Vector2.ZERO:
			grab_dir = player.get_dir()
		if grab_dir == Vector2.ZERO:
			grab_dir = Vector2(1,0)
			
		# Move to start position
		position = grab_dir * 250
		rotation = grab_dir.angle()	
		
		scale = Vector2(1.5,1.5)
		$SwipeTimer.start()
	



func _on_swipe_timer_timeout():
	scale = Vector2(0.8,0.8)
	rotation_degrees = 30
	time = 0.0
	ungrab()
	swiping = false
