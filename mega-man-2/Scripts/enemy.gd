extends Node2D

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Lemons"):
		damage()

func damage():
	queue_free()
