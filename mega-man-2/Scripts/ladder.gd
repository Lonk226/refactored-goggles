extends Area2D

@onready var collider: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2

func _physics_process(delta: float) -> void:
	if ray_cast_2d.is_colliding() or (Input.is_action_pressed("Down") and ray_cast_2d_2.is_colliding()):
		collider.disabled = true
	else:
		collider.disabled = false
