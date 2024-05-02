extends CharacterBody2D

@export var speed = 200

@export var score_value = 10

@onready var player = get_node("/root/main/Player")
@onready var color = GlobalFunctions.getRandFromList(["red", "orange", "grey", "green"]) + "_gumby"

func _physics_process(_delta):
	$AnimatedSprite2D.play(color)
	if (player.position.x <= position.x):
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	velocity = Vector2.ZERO
	velocity = position.direction_to(player.position) * speed
	move_and_slide()

