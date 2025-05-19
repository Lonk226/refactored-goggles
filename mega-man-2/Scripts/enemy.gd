extends Node2D

@export var health = 10 

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Lemons"):
		area.queue_free()
		damage()

func damage():
	health -= 1
	$"Hit Sound".playing = true
	if health == 0:
		die()

func die():
	queue_free()
