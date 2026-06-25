extends State

@export var idle_state: State
@export var walk_state: State
@export var run_state: State
@export var speed: float = 250.0
@export var air_control: float = 0.65

func enter_state() -> void:
	animated_sprite.play("fall")  # 先播放 "下落开始"（单次）

func update(_delta: float) -> void:
	# 落地
	if character.is_on_floor():
		if Input.get_axis("p_left", "p_right") != 0:
			if Input.is_action_pressed("p_run"):
				switch_state.emit(run_state)
			else:
				switch_state.emit(walk_state)
		else:
			switch_state.emit(idle_state)

func physics_update(_delta: float) -> void:
	var direction := Input.get_axis("p_left", "p_right")

	if direction != 0:
		character.velocity.x = direction * speed * air_control
		animated_sprite.scale.x = direction
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, speed * 0.2)

	# 重力
	character.velocity.y += character.gravity * _delta
	character.move_and_slide()
	character.push_crates(character.velocity)

	# 动画切换：fall（单次）播放完后切换到 fall_loop（循环）
	if animated_sprite.animation == "fall" and not animated_sprite.is_playing():
		animated_sprite.play("fall_loop")
