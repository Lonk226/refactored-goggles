extends Area2D

var speed1 = 80
var speed2 = 100
var shootnum: int
var dir

func _process(delta: float) -> void:
	if shootnum == 1:
		position.x += dir * delta * speed1
		position.y -= delta * speed1
	elif shootnum == 2:
		position.x += dir * delta * speed2
	elif shootnum == 3:
		position.x += dir * delta * speed1
		position.y += delta * speed1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.damage_player.emit()
		Global.mega_man_health -= 5

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
