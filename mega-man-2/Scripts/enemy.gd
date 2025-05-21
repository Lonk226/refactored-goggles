extends Node2D

@export var stats: Resource

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Lemons"):
		area.queue_free()
		hit()

func hit():
	stats.hp -= 1
	$"Hit Sound".playing = true
	if stats.hp == 0:
		die()

func die():
	queue_free()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.emit_signal("enemy_hit") 
