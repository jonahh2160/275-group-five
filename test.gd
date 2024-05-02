extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	$AnimatedSprite2D2.play("exploding")

func _on_mouse_exited():
	$AnimatedSprite2D2.play("still_image")
