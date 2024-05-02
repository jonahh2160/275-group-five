extends Control

func _ready():
	$CenterContainer/VBoxContainer/PlayAgain.grab_focus()

func _on_quit_pressed():
	get_tree().quit()

func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/title.tscn")
