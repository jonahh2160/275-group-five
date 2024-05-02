extends Control

func _ready():
	$VBoxContainer/MarginContainer3/Resume.grab_focus()

func _on_exit_to_screen_pressed():
	get_tree().paused = false
	get_tree().quit()

func _on_exit_to_main_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/title.tscn")

func _on_resume_pressed():
	get_tree().paused = false
	queue_free()
