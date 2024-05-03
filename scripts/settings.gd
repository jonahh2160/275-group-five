extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if (GlobalFunctions.secret_sound):
		$Secret.set_pressed_no_signal()
	$Button.grab_focus()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/title.tscn")

func _on_check_box_toggled(toggled_on):
	if GlobalFunctions.secret_sound:
		GlobalFunctions.secret_sound = false
	else:
		GlobalFunctions.secret_sound = true
