extends CharacterBody2D

@export var speed = 200

@onready var player = get_node("/root/main/Player")

var blowing_up = false
var required_distance_for_boom = 180
var number_of_blinks = 10
var bomb_timer = .8
@export var explosion: PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (blowing_up):
		pass
	else:
		var player_distance = Vector2(position-player.position).length()
		if ((player_distance >= 0 and player_distance < required_distance_for_boom) or (player_distance <= 0 and player_distance > (-1 * required_distance_for_boom))):
			blowing_up = true
			blow_up()
		else:
			normal_move(delta)


func normal_move(delta):
	velocity = Vector2.ZERO
	velocity = position.direction_to(player.position) * speed
	position += velocity * delta

func blow_up():
	var loop = 1
	while (number_of_blinks > 0):
		set_modulate(Color("red"))
		await get_tree().create_timer(.4 - (.04 * loop)).timeout
		set_modulate(Color(1, 1, 1, 1))
		await get_tree().create_timer(bomb_timer).timeout
		bomb_timer -= 0.08 * loop
		if (bomb_timer <= 0):
			bomb_timer = 0.01
		loop += 1
		number_of_blinks -= 1
	var boom = explosion.instantiate()
	boom.position = position
	add_sibling(boom)
	queue_free()
