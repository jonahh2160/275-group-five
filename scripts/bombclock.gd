extends CharacterBody2D

@export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	var player = get_node("/root/main/Player")
	velocity = position.direction_to(player.position) * speed
	position += velocity * delta
