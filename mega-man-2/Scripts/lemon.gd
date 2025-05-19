extends Area2D

var dir
var speed = 250

func _process(delta: float) -> void:
	position.x += speed * dir * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
