extends CharacterBody2D

@export var speed = 200

@export var score_value = 15

@onready var player = get_node("/root/main/Player")

var blowing_up = false
var required_distance_for_boom = 180
var count_down = 5
var direction_from_player = 0# 0 up/down, 1 left, 2 right
@export var explosion: PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (blowing_up):
		pass
	else: 
		var player_distance = Vector2(position-player.position).length()
		if ((player_distance >= 0 and player_distance < required_distance_for_boom) or (player_distance <= 0 and player_distance > (-1 * required_distance_for_boom))):
			match direction_from_player:
				0:
					$AnimatedSprite2D.play("Frount Alert")
				1: 
					$AnimatedSprite2D.play("Left Alert")
				2:
					$AnimatedSprite2D.play("Right Alert")
			blowing_up = true
			$AudioStreamPlayer2D3.pitch_scale = randf_range(1, 2)
			$AudioStreamPlayer2D3.play()
			$Timer.start()
		else:
			normal_move()


func normal_move():
	if (player.position.x - position.x > -60 and player.position.x - position.x < 60):
		$AnimatedSprite2D.play("Frount Smile")
		direction_from_player = 0
	elif (player.position.x <= position.x):
		$AnimatedSprite2D.play("Left Smile")
		direction_from_player = 1
	elif (player.position.x >= position.x):
		$AnimatedSprite2D.play("Right Smile")
		direction_from_player = 2
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
		match direction_from_player:
				0:
					$AnimatedSprite2D.play("Frount 5")
				1: 
					$AnimatedSprite2D.play("Left 5")
				2:
					$AnimatedSprite2D.play("Right 5")
		$AudioStreamPlayer2D.play()
		count_down -= 1
	elif (count_down == 4):
		match direction_from_player:
				0:
					$AnimatedSprite2D.play("Frount 4")
				1: 
					$AnimatedSprite2D.play("Left 4")
				2:
					$AnimatedSprite2D.play("Right 4")
		$AudioStreamPlayer2D.play()
		count_down -= 1
	elif (count_down == 3):
		match direction_from_player:
				0:
					$AnimatedSprite2D.play("Frount 3")
				1: 
					$AnimatedSprite2D.play("Left 3")
				2:
					$AnimatedSprite2D.play("Right 3")
		$AudioStreamPlayer2D.play()
		count_down -= 1
	elif (count_down == 2):
		match direction_from_player:
				0:
					$AnimatedSprite2D.play("Frount 2")
				1: 
					$AnimatedSprite2D.play("Left 2")
				2:
					$AnimatedSprite2D.play("Right 2")
		$AudioStreamPlayer2D.play()
		count_down -= 1
	elif (count_down == 1):
		match direction_from_player:
				0:
					$AnimatedSprite2D.play("Frount 1")
				1: 
					$AnimatedSprite2D.play("Left 1")
				2:
					$AnimatedSprite2D.play("Right 1")
		$AudioStreamPlayer2D.play()
		count_down -= 1
		$Timer.one_shot = true
	else:
		match direction_from_player:
				0:
					$AnimatedSprite2D.play("Frount Shock")
				1: 
					$AnimatedSprite2D.play("Left Shock")
				2:
					$AnimatedSprite2D.play("Right Shock")
		$AudioStreamPlayer2D2.play()
		await get_tree().create_timer(0.5).timeout
		blow_up()
