extends CharacterBody2D
signal hit

@export var speed = 600
@export var accel = 10
@export var health = 6

var dir = Vector2.ZERO

var state = 0
var i_frames = 0
var phase = 0
var timer = 0
var screen_size
var dash_angle
var dashing
var timer_on = false


func _ready():
	screen_size = get_viewport_rect().size

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _physics_process(delta):
	dir = get_dir()
	
	match state:
		0:
			free_state(delta)
		1:
			dodge(delta)
	
	# I-Frame reduction + flash
	if i_frames > 0:
		i_frames = i_frames - 1
		if i_frames <= 0:
			set_modulate(Color(1, 1, 1))

	move_and_slide()

func free_state(delta):
	# Dodge
	if (Input.is_action_pressed("dodge") and dir):
		state = 1
		
	# Credit to KobeDev on YouTube
	velocity = lerp(velocity, dir * speed, delta * accel)

func dodge(delta):
	
	i_frames = 10
	
	if timer_on:
		# Timer is on and dashing: so process the dash itself
		if dashing:
			velocity += (dash_angle * speed * 2 * delta)
			
		# Timer is already processing, don't create a new one! So return
		# Code will go back to where the timer was created when it times out
		return
	else:
		if not dashing:
			# Set dash angle and start a timer
			dash_angle = dir * 2 # TODO: Why *2?
			timer_on = true
			await get_tree().create_timer(0.05).timeout
			# On timeout, stop timer and start dashing
			timer_on = false
			dashing = true
		else:
			# Start dash
			timer_on = true
			await get_tree().create_timer(0.5).timeout
			# Reset variables and return to free state on timeout
			timer_on = false
			dashing = false
			state = 0

func get_dir():
	dir.x = Input.get_axis("move_left", "move_right")
	dir.y = Input.get_axis("move_up", "move_down")
	return dir.normalized()

func _on_area_2d_body_entered(body):
	if i_frames <= 0:
		health -= 1
		set_modulate(Color("red"))
		hit.emit()
		i_frames += 75
	if health <= 0:
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true) # Don't want player to get hit twiceace with function body.
		# Must be deferred as we can't change physics properties on a physics callback.
		await get_tree().create_timer(1).timeout
		call_deferred("game_over")

func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
