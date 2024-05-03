extends Control

var secret_spawn_sound = load("res://snd/metalpipe.mp3")
var base_spawn_sound

# Called when the node enters the scene tree for the first time.
func _ready():
	if (GlobalFunctions.enemy_spawn_sound == secret_spawn_sound):
		$Secret.button_pressed = true
	$Button.grab_focus()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/title.tscn")


func _on_check_box_toggled(toggled_on):
	if GlobalFunctions.enemy_spawn_sound != secret_spawn_sound:
		GlobalFunctions.enemy_spawn_sound = secret_spawn_sound
	else:
		GlobalFunctions.enemy_spawn_sound = base_spawn_sound
