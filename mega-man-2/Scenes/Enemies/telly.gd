extends Node2D

var speed = 100

func _on_telly_death() -> void:
	$Normal.visible = false

func _physics_process(delta: float) -> void:
	pass
