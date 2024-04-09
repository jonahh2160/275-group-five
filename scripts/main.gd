extends Node

@export var bombEnemy_scene: PackedScene
@export var wheelEnemy_scene: PackedScene

var mobSpawnerList
var enemyList
# Called when the node enters the scene tree for the first time.
func _ready():
	mobSpawnerList = $MobSpawners.get_children()
	enemyList = [bombEnemy_scene, wheelEnemy_scene]
	spawn_enemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_enemy():
	var enemyToSpawn = GlobalFunctions.getRandFromList(enemyList).instantiate()
	var useSpawner = GlobalFunctions.getRandFromList(mobSpawnerList)
	enemyToSpawn.position = useSpawner.position
	useSpawner.add_sibling(enemyToSpawn)

func _on_player_hit():
	$HUD.update_health(str($Player.health))
