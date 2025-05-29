extends Area2D

var dir
var speed = 250
var bouncing = false

func _process(delta: float) -> void:
	if bouncing:
		position.x -= speed * dir * delta
		position.y -= speed * delta
	else:
		position.x += speed * dir * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func bounce():
	bouncing = true
