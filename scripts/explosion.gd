extends Area2D

func _ready():
	$CollisionShape2D.apply_scale()
	$AnimatedSprite2D.play("boom")
	$CollisionShape2D.scale = move_toward(0, 1, 0.2)
	$BoomPlayer.play()

func _on_boom_player_finished():
	queue_free()
