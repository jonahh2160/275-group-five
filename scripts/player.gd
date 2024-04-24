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
var dashing
var dash_angle

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
		
	if i_frames > 0 and is_visible() and not dashing:
		damage_flash()
		
	move_and_slide()

func free_state(delta):
	# Dodge
	if (Input.is_action_pressed("dodge") and dir):
		state = 1
		
	# Credit to KobeDev on YouTube
	velocity = lerp(velocity, dir * speed, delta * accel)

func dodge(delta):
	# Set dash angle and start a timer
	# On timeout, give iframes and start dashing; add another timer
	# When THAT timer ends, return stop dashing and return to state 0
	
	match phase:
		0:
			dash_angle = dir * 2
			timer = 1
			phase = 1
		1:
			if timer > 0:
				timer -= 1
			else:
				phase = 2
		2:
			i_frames = 60
			timer = 20
			dashing = true
			phase = 3
		3:
			if timer > 0:
				timer -= 1
			else:
				phase = 4
		4:
			state = 0
			phase = 0
			dashing = false
			
	if dashing:
		velocity += (dash_angle * speed * 2 * delta)	

func get_dir():
	dir.x = Input.get_axis("move_left", "move_right")
	dir.y = Input.get_axis("move_up", "move_down")
	return dir.normalized()

func damage_flash():
	if not is_visible():
		return
	else:
		hide()
		await get_tree().create_timer(0.02).timeout # wait for 1 second
		show()

func _on_area_2d_body_entered(body):
	if i_frames <= 0:
		health -= 1
		hit.emit()
		i_frames += 75
	if health <= 0:
		hide() # Player disappears after being hit.
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true) # Don't want player to get hit twiceace with function body.
		call_deferred("game_over")

func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
