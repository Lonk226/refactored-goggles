extends Node2D

@export var stats: Resource

@onready var health = stats.hit_points

var dead = false
var on_player = false

signal death()

func _process(delta: float) -> void:
	if on_player:
		damage_player()

func hit():
	health -= 1
	$"Pattern/Hit Sound".playing = true
	if health <= 0:
		die()

func die():
	dead = true
	death.emit()
	$"Pattern/Death Effect".play("Death")
	await get_tree().create_timer(0.33333).timeout
	queue_free()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		on_player = true

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Lemons") and not dead:
		area.queue_free()
		hit()

func damage_player():
	if not Global.player_invincible and not dead:
		Global.mega_man_health -= stats.damage
		Global.damage_player.emit()


func _on_hurtbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		on_player = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
