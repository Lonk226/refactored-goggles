extends Node2D

@onready var anim: TileMapLayer = $Tiles/Anim
@onready var tile_timer: Timer = $Tiles/TileTimer
var anim_on = true
var lemon_scene = preload("res://Scenes/Projectiles/lemon.tscn")
var shoot_dir

func _on_tile_timer_timeout() -> void:
	if anim_on == true:
		anim_on = false
	elif anim_on == false:
		anim_on = true

func _process(delta: float) -> void:
	if anim_on == true:
		anim.visible = true
	else:
		anim.visible = false
	if Global.facing_right:
		shoot_dir = 1
	elif not Global.facing_right:
		shoot_dir = -1

func _on_mega_man_shoot_signal(pos: Vector2) -> void:
	var lemon = lemon_scene.instantiate()
	if get_tree().get_nodes_in_group("Lemons").size() < 3:
		add_child(lemon)
		lemon.dir = shoot_dir
		lemon.global_position = pos + Vector2(shoot_dir * 16, -2)
		lemon.add_to_group("Lemons")
