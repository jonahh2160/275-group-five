extends Control


func _on_area_2d_mouse_entered():
	$Area2D/AnimatedSprite2D.play("exploding")

func _on_area_2d_mouse_exited():
	$Area2D/AnimatedSprite2D.play("still_image")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/title.tscn")
