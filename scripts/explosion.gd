extends Area2D

var score_value = 0

func _ready():
	$AnimatedSprite2D.play("boom")
	$BoomPlayer.play()
	$CollisionShape2D.hide()

func _on_boom_player_finished():
	queue_free()


func _on_body_exited(body):
	body._on_area_2d_body_entered(body)
