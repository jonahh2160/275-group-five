extends Area2D

func _ready():
	$AnimatedSprite2D.play("boom")
	$BoomPlayer.play()
	$CollisionShape2D.hide()

func _on_boom_player_finished():
	queue_free()


func _on_body_exited(body):
	body.queue_free()


func _on_body_entered(body):
	body.queue_free()
