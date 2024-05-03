extends Node

var enemy_spawn_sound
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	enemy_spawn_sound = load("res://snd/metalpipe.mp3")

# this is not new, this is the recommended way to get something similar to rand.choice()
func getRandFromList(list):
	return list[randi() % list.size()]
