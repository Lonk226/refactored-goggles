extends CharacterBody2D

@onready var normal_sprite: AnimatedSprite2D = $NormalSprite2D
@onready var shoot_sprite: AnimatedSprite2D = $ShootSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@export var walk_speed: float = 82.5
@export var air_speed: float = 78.75
@export var ladder_speed: float = 50
@export var jump_height: float = 50 # height of jump
@export var jump_time_to_peak: float = 0.333 # length of jump
@export var jump_time_to_descent: float = 0.333 # length of fall
@export var max_fall_speed: float = 720
var frozen = false
var inching = false
var shooting = false
var can_go_on_ladder = false
var up_state = false
var is_grounded = true

signal shoot_signal(pos: Vector2)

func _physics_process(delta: float) -> void:
	if not frozen:
		var jump_speed: float = ((2 * jump_height) / jump_time_to_peak) * -1 # speed of jump
		var jump_gravity: float = ((-2 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1 # gravity while jumping
		var fall_gravity: float = ((-2 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1 # gravity while falling
		gravity(delta, jump_gravity, fall_gravity)
		jump(jump_speed)
		move()
		shoot()
		climb()
		get_on_ladder()
		up_on_ladder()
		jumpcut()
		inch()
		land()
		underwater_physics()
		flip_the_sprite()
		change_sprite()
		move_and_slide()
	play_animation()

func move():
	var dir := Input.get_axis("Left", "Right")
	if not Global.on_ladder:
		if dir:
			if is_on_floor():
				velocity.x = dir * walk_speed
			else:
				velocity.x = dir * air_speed 
		else:
			velocity.x = move_toward(velocity.x, 0, walk_speed)

func jump(jump_speed):
	if Input.is_action_just_pressed("A") and is_on_floor():
		velocity.y += jump_speed
	if Input.is_action_just_pressed("A") and Global.on_ladder:
		Global.on_ladder = false

func play_animation():
	var dir := Input.get_axis("Left", "Right")
	if not is_on_floor():
		if Global.on_ladder:
			if up_state:
				normal_sprite.play("Up")
				shoot_sprite.play("Up")
			if velocity.y == 0:
				normal_sprite.pause()
				shoot_sprite.pause()
			else:
				if not up_state:
					normal_sprite.play("Ladder")
					shoot_sprite.play("Ladder")
		else:
			normal_sprite.play("Jump")
			shoot_sprite.play("Jump")
	elif dir:
		if inching:
			normal_sprite.play("Inch")
			shoot_sprite.play("Idle")
		else:
			normal_sprite.play("Walk")
			shoot_sprite.play("Walk")
	else:
		normal_sprite.play("Idle")
		shoot_sprite.play("Idle")

func flip_the_sprite():
	var dir := Input.get_axis("Left", "Right")
	if dir == 1:
		normal_sprite.flip_h = false
		shoot_sprite.flip_h = false
		Global.facing_right = true
	if dir == -1:
		normal_sprite.flip_h = true
		shoot_sprite.flip_h = true
		Global.facing_right = false

func gravity(delta, jump_gravity, fall_gravity):
	if not Global.on_ladder:
		if not is_on_floor():
			velocity.y += getgravity(jump_gravity, fall_gravity) * delta
			if velocity.y > max_fall_speed:
				velocity.y = max_fall_speed

func jumpcut():
	if Input.is_action_just_released("A"):
		if velocity.y < -60:
			velocity.y = -60

func getgravity(jump_gravity, fall_gravity): # tell what the current gravity should be
	if velocity.y < 0:
		return jump_gravity
	else:
		return fall_gravity

func inch():
	if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right"):
		inching = true
		await get_tree().create_timer(0.08).timeout
		inching = false

func underwater_physics():
	if Global.underwater:
		jump_height = 132
		jump_time_to_peak = 1
		jump_time_to_descent = 1
	else:
		jump_height = 50
		jump_time_to_peak = 0.333
		jump_time_to_descent = 0.333

func shoot():
	if Input.is_action_just_pressed("B"):
		if get_tree().get_nodes_in_group("Lemons").size() < 3:
			$"Buster Shot".playing = true
			shooting = true
			shoot_signal.emit(global_position)
			await get_tree().create_timer(0.8).timeout
			shooting = false

func change_sprite():
	if shooting:
		normal_sprite.visible = false
		shoot_sprite.visible = true
	else:
		normal_sprite.visible = true
		shoot_sprite.visible = false

func climb():
	var updir = Input.get_axis("Up","Down")
	if Global.on_ladder:
		velocity.x = 0
		#global_position.x = $RayCast2D.get_collider().global_position.x
		if updir and not shooting:
			velocity.y = updir * ladder_speed
		else:
			velocity.y = move_toward(velocity.y, 0, ladder_speed)
	if is_on_floor():
		Global.on_ladder = false
	if $RayCast2D.is_colliding() and is_on_floor() and updir == 1:
		position.y += -2
	if not $RayCast2D.is_colliding():
		Global.on_ladder = false

func get_on_ladder():
	var updir = Input.get_axis("Up","Down")
	if $RayCast2D.is_colliding():
		if updir == 1:
			if not Global.on_ladder:
				position.y += 10
			Global.on_ladder = true
			global_position.x = $RayCast2D.get_collider().global_position.x
	if $RayCast2D3.is_colliding():
		if updir == -1:
			Global.on_ladder = true
			global_position.x = $RayCast2D3.get_collider().global_position.x

func up_on_ladder():
	var updir = Input.get_axis("Up","Down")
	if not $RayCast2D2.is_colliding() and Global.on_ladder:
		up_state = true
	else:
		up_state = false
	if not $RayCast2D4.is_colliding() and Global.on_ladder and updir == -1:
		position.y -= 3

func land():
	if not is_grounded and is_on_floor():
		$Land.playing = true
	is_grounded = is_on_floor()
