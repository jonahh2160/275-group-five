extends CharacterBody2D

@export var speed = 200

@onready var player = get_node("/root/main/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	normal_move(delta)


func normal_move(delta):
	velocity = Vector2.ZERO
	velocity = position.direction_to(player.position) * speed
	position += velocity * delta

func speacial_move():
	pass
