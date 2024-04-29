extends Node

@export var bombEnemy_scene: PackedScene
@export var wheelEnemy_scene: PackedScene
@export var rumbee_scene: PackedScene

var mobSpawnerList
var enemyList
var wave = 0
var base_num_enemies = 2
var enemies_to_spawn
# Called when the node enters the scene tree for the first time.
func _ready():
	mobSpawnerList = $MobSpawners.get_children()
	enemyList = [bombEnemy_scene, wheelEnemy_scene, rumbee_scene]
	start_next_wave()

func spawn_enemy():
	var enemyToSpawn = GlobalFunctions.getRandFromList(enemyList).instantiate()
	var useSpawner = GlobalFunctions.getRandFromList(mobSpawnerList)
	enemyToSpawn.position = useSpawner.position
	useSpawner.get_parent().get_parent().get_node("Enemies").add_child(enemyToSpawn)

func _on_player_hit():
	$HUD.update_health(str($Player.health))

func start_next_wave():
	wave += 1
	enemies_to_spawn = base_num_enemies + wave
	while (enemies_to_spawn > 0):
		await get_tree().create_timer(.3).timeout
		spawn_enemy()
		enemies_to_spawn -= 1


func _on_check_for_enemies_timeout():
	if (get_node("Enemies").get_child_count() == 0):
		start_next_wave()
