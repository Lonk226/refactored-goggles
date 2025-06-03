extends Marker2D

@export var enemy_scene: PackedScene


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	spawn()

func spawn():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = global_position
