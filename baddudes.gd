extends RigidBody2D

@export var speed = 200
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	var xmove = get_parent().get_node("Player").position.x - position.x
	var ymove = get_parent().get_node("Player").position.y - position.y
	if (xmove > 0):
		velocity.x += 1
	elif (xmove == 0):
		pass
	else:
		velocity.x -= 1
	if (ymove > 0):
		velocity.y += 1
	elif (ymove == 0):
		pass
	else:
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
