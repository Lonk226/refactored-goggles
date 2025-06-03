extends Node2D

var speed = 300

func _on_telly_death() -> void:
	$Normal.visible = false

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	global_position += (player.global_position - global_position)/ speed
	if not $VisibleOnScreenNotifier2D.is_on_screen():
		queue_free()
