extends Marker2D

@export var enemy_scene: PackedScene

func spawn():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = global_position


func _on_timer_timeout() -> void:
	spawn()
