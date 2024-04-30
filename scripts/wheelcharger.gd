extends CharacterBody2D

@export var speed = 200
var charge_speed = speed * 5

@export var score_value = 20

@onready var player = get_node("/root/main/Player")

var charging_up = false
var charged_up = false
var required_distance_to_charge = 400
var num_blinks = 3
var tracked_player_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (player.position.x >= position.x):
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	if (charging_up):
		if (charged_up):
			charge(delta)
		else:
			pass
	else:
		var player_distance = Vector2(position-player.position).length()
		if ((player_distance >= 0 and player_distance < required_distance_to_charge) or (player_distance <= 0 and player_distance > (-1 * required_distance_to_charge))):
			charging_up = true
			charge_up()
			$ChargeTimer.start()
		else:
			normal_move(delta)


func normal_move(delta):
	velocity = Vector2.ZERO
	velocity = position.direction_to(player.position) * speed
	move_and_slide()

func charge_up():
	while (num_blinks > 0):
		set_modulate(Color("purple"))
		await get_tree().create_timer(.5).timeout
		set_modulate(Color(1, 1, 1, 1))
		tracked_player_pos = player.position
		await get_tree().create_timer(.5).timeout
		num_blinks -= 1
	charged_up = true

func charge(delta):
	velocity = Vector2.ZERO
	velocity = position.direction_to(tracked_player_pos) * charge_speed
	position += velocity * delta
	if (position.x - tracked_player_pos.x < 20 and position.x - tracked_player_pos.x > -20 and position.y - tracked_player_pos.y < 20 and position.y - tracked_player_pos.y > -20):
		num_blinks = 3
		charged_up = false
		charging_up = false
		$ChargeTimer.stop()



func _on_charge_timer_timeout():
	num_blinks = 3
	charged_up = false
	charging_up = false
