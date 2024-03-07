extends Area2D
signal hit

@export var max_vel = 400
@export var accel = 1500
@export var decel = 600

var velocity = Vector2()
var dir = Vector2.ZERO
var state = 0
var i_frames = 0
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		0:
			movement(delta)
		1:
			dodge(delta)
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func get_dir():
	dir.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	dir.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return dir.normalized()

func movement(delta):
	dir = get_dir()
	
	if dir == Vector2.ZERO:
		if velocity.length() > (decel * delta):
			velocity -= velocity.normalized() * (decel * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (dir * accel * delta)
		velocity = velocity.limit_length(max_vel)

func dodge(delta):
	pass
