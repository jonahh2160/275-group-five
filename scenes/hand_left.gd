extends Area2D

@export var current_held = 0
var grabbing = false
var grab_dir = Vector2.ZERO

func grab(dir):
	grab_dir = dir
	grabbing = true
	rotation = grab_dir.angle()	
	$GrabTimer.start()

func _process(delta):
	print ($GrabTimer.get_time_left())
	if $GrabTimer.get_time_left() > 0:
		position += grab_dir.normalized() * 400 * delta

func _on_body_entered(body):
	if grabbing:
		match body.name:
			"Bombclock":
				current_held = 1
			"Wheelcharger":
				current_held = 2

func _on_grab_timer_timeout():
	# TODO: Return to initial position
	grabbing = false
