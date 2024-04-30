extends CanvasLayer

signal hurt_timer_timout

var ability_to_hide

func _on_hurt_timer_timeout():
	hurt_timer_timout.emit()

func show_ability(enemy_num):
	match enemy_num:
		1:
			$Ability/bomb.show()
		2:
			$Ability/mouse.show()
		3:
			$Ability/stone.show()
	ability_to_hide = enemy_num

func hide_ability():
	match ability_to_hide:
		1:
			$Ability/bomb.hide()
		2:
			$Ability/mouse.hide()
		3:
			$Ability/stone.hide()
