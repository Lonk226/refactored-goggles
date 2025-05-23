extends Node2D

@export var stats: Resource

@onready var health = stats.hit_points

var dead = false

signal death()

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
	if body.is_in_group("Player") and not Global.player_invincible and not dead:
		Global.mega_man_health -= stats.damage
		Global.damage_player.emit()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Lemons") and not dead:
		area.queue_free()
		hit()
