extends State

@export var fall_state: State
@export var idle_state: State
@export var speed: float = 250.0
@export var air_control: float = 0.65  # 空中水平控制系数

func enter_state() -> void:
	animated_sprite.play("jump")
	character.velocity.y = character.jump_velocity

	# 进入跳跃时保留当前的朝向
	var direction := Input.get_axis("p_left", "p_right")
	if direction != 0:
		animated_sprite.scale.x = direction

func update(_delta: float) -> void:
	# 达到最高点或开始下落 → Fall
	if character.velocity.y >= 0:
		switch_state.emit(fall_state)
		return

	# 意外落地（踩到头顶平台等）
	if character.is_on_floor():
		if Input.get_axis("p_left", "p_right") != 0:
			switch_state.emit(idle_state)  # idle 会立即切到 Run
		else:
			switch_state.emit(idle_state)

func physics_update(_delta: float) -> void:
	var direction := Input.get_axis("p_left", "p_right")

	if direction != 0:
		character.velocity.x = direction * speed * air_control
		animated_sprite.scale.x = direction
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, speed * 0.3)

	# 重力
	character.velocity.y += character.gravity * _delta
	character.move_and_slide()
	character.push_crates(character.velocity)
