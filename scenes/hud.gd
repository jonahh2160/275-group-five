extends CanvasLayer

signal hurt_timer_timout

func _on_hurt_timer_timeout():
	hurt_timer_timout.emit()
