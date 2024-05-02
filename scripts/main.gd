extends Node

@export var bombEnemy_scene: PackedScene
@export var wheelEnemy_scene: PackedScene
@export var rumbee_scene: PackedScene

var mobSpawnerList
var enemyList
var wave = 0
var score = 0
var base_num_enemies = 2
var cur_enemy_count = 0
var enemies_to_spawn
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	mobSpawnerList = $MobSpawners.get_children()
	enemyList = [bombEnemy_scene, wheelEnemy_scene, rumbee_scene]
	start_next_wave()

func spawn_enemy():
	var enemyToSpawn = GlobalFunctions.getRandFromList(enemyList).instantiate()
	var useSpawner = GlobalFunctions.getRandFromList(mobSpawnerList)
	enemyToSpawn.position = useSpawner.position
	useSpawner.get_parent().get_parent().get_node("Enemies").add_child(enemyToSpawn)

func _on_player_hit():
	var health = player.health
	
	if health > 0:
		$HUD/HealthLabel/StartBar.play("Hurt Right")
		$HUD/HurtTimer.start()
	
	if health == 4:
		$HUD/HealthLabel/EndBar.play("empty")
	elif health == 3:
		$HUD/HealthLabel/MidBar3.play("empty")
	elif health == 2:
		$HUD/HealthLabel/MidBar2.play("empty")
	elif health == 1:
		$HUD/HealthLabel/MidBar.play("empty")
	elif health <= 0:
		$AudioStreamPlayer.stop()
		$HUD/HealthLabel/StartBar.play("Dead Right")

func _on_hud_hurt_timer_timout():
	if player.health > 0:
		$HUD/HealthLabel/StartBar.play("Normal Right")

func start_next_wave():
	wave += 1
	$HUD/MarginContainer/VBoxContainer/WaveLabel.text = "Wave: " + str(wave)
	enemies_to_spawn = base_num_enemies + wave
	while (enemies_to_spawn > 0):
		await get_tree().create_timer(.3).timeout
		spawn_enemy()
		enemies_to_spawn -= 1

func _on_check_for_enemies_timeout():
	if (get_node("Enemies").get_child_count() == 0):
		start_next_wave()

func _on_enemies_child_exiting_tree(node):
	score += node.score_value
	cur_enemy_count -= 1
	$HUD/MarginContainer/VBoxContainer/ScoreLabel.text = "Score: " + str(score)
	$HUD/EnemiesLeftLabel.text = "Enemies left: " + str(cur_enemy_count)


func _on_player_enemy_held():
	$HUD.show_ability($Player/HandLeft.current_held)


func _on_player_discarded():
	$HUD.hide_ability()


func _on_enemies_child_entered_tree(_node):
	cur_enemy_count += 1
	$HUD/EnemiesLeftLabel.text = "Enemies left: " + str(cur_enemy_count)
