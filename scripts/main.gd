extends Node

@export var bombEnemy_scene: PackedScene
@export var wheelEnemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bombE = bombEnemy_scene.instantiate()
	if (Input.is_action_pressed("spawn")):
		add_child(bombE)


func _on_player_hit():
	$HUD.update_health(str($Player.health))
