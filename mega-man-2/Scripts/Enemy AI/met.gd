extends Node2D

var gravity = 100
var hiding = true
var dir = 1
@onready var normal: AnimatedSprite2D = $Normal
var projscene = preload("res://Scenes/Projectiles/met_projectile.tscn")

func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if hiding:
		normal.play("Idle")
		$Hurtbox.set_collision_layer_value(2, false)
		$Hurtbox.set_collision_mask_value(2, false)
		$Bouncer/CollisionShape2D.disabled = false
	else:
		normal.play("Lift")
		$Hurtbox.set_collision_layer_value(2, true)
		$Hurtbox.set_collision_mask_value(2, true)
		$Bouncer/CollisionShape2D.disabled = true
	if player.global_position.x < global_position.x:
		normal.flip_h = false
		dir = -1
	elif player.global_position.x > global_position.x:
		normal.flip_h = true
		dir = 1

func lift():
	hiding = false
	await get_tree().create_timer(0.2).timeout
	if not get_parent().dead:
		shoot()
	await get_tree().create_timer(0.4).timeout
	hiding = true

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

func shoot():
	var proj1 = projscene.instantiate()
	var proj2 = projscene.instantiate()
	var proj3 = projscene.instantiate()
	add_child(proj1)
	add_child(proj2)
	add_child(proj3)
	proj1.dir = dir
	proj2.dir = dir
	proj3.dir = dir
	proj1.shootnum = 1
	proj2.shootnum = 2
	proj3.shootnum = 3
