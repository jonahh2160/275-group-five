extends Area2D
signal hit

@export var max_vel = 600
@export var accel = 4000
@export var decel = 3500
@export var health = 6

var velocity = Vector2()
var dir = Vector2.ZERO
var state = 0
var i_frames = 0
var phase = 0
var timer = 0
var screen_size
var dash_angle
var dashing

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dir = get_dir()
	
	if (Input.is_action_pressed("dodge")):
		state = 1
	
	match state:
		0:
			free_state(delta)
		1:
			dodge(delta)
	
	if i_frames > 0:
		i_frames = i_frames - 1
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func get_dir():
	dir.x = Input.get_axis("move_left", "move_right")
	dir.y = Input.get_axis("move_up", "move_down")
	return dir.normalized()

func free_state(delta):
	if dir == Vector2.ZERO:
		if velocity.length() > (decel * delta):
			# Slow down
			velocity -= velocity.normalized() * (decel * delta)
		else:
			# No velocity
			velocity = Vector2.ZERO
	else:
		# Move with respect to maximum speed
		velocity += dir * accel * delta
		velocity = velocity.limit_length(max_vel)

func dodge(delta):
	match phase:
		0:
			dash_angle = dir * 2
			dashing = false
			timer = 30
			phase = 1
		1:
			if timer > 0:
				timer -= 1
			else:
				phase = 2
		2:
			i_frames = 60
			timer = 60
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
			
	if dashing:
		velocity += (dash_angle * accel * delta)
		

func _on_body_entered(body):
	if i_frames == 0:
		health -= 1
		hit.emit()
		i_frames += 150
	if health == 0:
		hide() # Player disappears after being hit.
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true) # Don't want player to get hit twice

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
