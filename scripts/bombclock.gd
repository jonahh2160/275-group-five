extends CharacterBody2D

@export var speed = 200

@export var score_value = 15

@onready var player = get_node("/root/main/Player")

var blowing_up = false
var required_distance_for_boom = 180
var count_down = 5
@export var explosion: PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (blowing_up):
		pass
	else:
		var player_distance = Vector2(position-player.position).length()
		if ((player_distance >= 0 and player_distance < required_distance_for_boom) or (player_distance <= 0 and player_distance > (-1 * required_distance_for_boom))):
			$AnimatedSprite2D.play("Alert Walk")
			$AnimatedSprite2D.flip_h = false
			blowing_up = true
			$Timer.start()
		else:
			normal_move()


func normal_move():
	if (player.position.x <= position.x):
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("Smile Walk")
	velocity = Vector2.ZERO
	velocity = position.direction_to(player.position) * speed
	move_and_slide()

func blow_up():
	var boom = explosion.instantiate()
	boom.position = position
	add_sibling(boom)
	queue_free()


func _on_timer_timeout():
	if (count_down == 5):
		$AnimatedSprite2D.play("5 Walk")
		count_down -= 1
	elif (count_down == 4):
		$AnimatedSprite2D.play("4 Walk")
		count_down -= 1
	elif (count_down == 3):
		$AnimatedSprite2D.play("3 Walk")
		count_down -= 1
	elif (count_down == 2):
		$AnimatedSprite2D.play("2 Walk")
		count_down -= 1
	elif (count_down == 1):
		$AnimatedSprite2D.play("1 Walk")
		count_down -= 1
		$Timer.one_shot = true
	else:
		$AnimatedSprite2D.play("Shock Walk")
		await get_tree().create_timer(0.5).timeout
		blow_up()
