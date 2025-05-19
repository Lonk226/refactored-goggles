extends Camera2D

@onready var mega_man: CharacterBody2D = $"../Mega Man"


func _process(delta: float) -> void:
	global_position.x = mega_man.global_position.x

func _on_camera_move_up_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if Global.on_ladder:
			cam_transition(self, "position", Vector2(mega_man.global_position.x, global_position.y - 240), 1.5)
			mega_man.frozen = true
			mega_man.global_position.y -= 5
			await get_tree().create_timer(1.5).timeout
			mega_man.frozen = false

func _on_camera_move_down_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		cam_transition(self, "position", Vector2(mega_man.global_position.x, global_position.y + 240), 1.5)
		mega_man.frozen = true
		mega_man.global_position.y += 5
		await get_tree().create_timer(1.5).timeout
		mega_man.frozen = false

func cam_transition(node, property, final_value: Vector2, duration):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(node, property, final_value, duration)
