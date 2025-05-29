extends Node2D

var gravity = 100
var hiding = true
@onready var normal: AnimatedSprite2D = $Normal

func _process(delta: float) -> void:
	if hiding:
		normal.play("Idle")
		$Hurtbox.set_collision_layer_value(2, false)
		$Bouncer/CollisionShape2D.disabled = false
	else:
		normal.play("Lift")
		$Hurtbox.set_collision_layer_value(2, true)
		$Bouncer/CollisionShape2D.disabled = true

func lift():
	hiding = false
	await get_tree().create_timer(0.5).timeout
	hiding = true

func run():
	pass

func _on_met_death() -> void:
	$Normal.visible = false


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$Timer.start()
		lift()

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$Timer.stop()

func _on_timer_timeout() -> void:
	lift()
