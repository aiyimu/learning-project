extends State

@export var idle_state: State
@export var run_state: State
@export var jump_state: State
@export var fall_state: State
@export var combo_1_state: State
@export var speed: float = 250.0

func enter_state() -> void:
	# 进入 Walk 时根据当前水平输入方向设置朝向和动画
	var direction := Input.get_axis("p_left", "p_right")
	if direction != 0:
		animated_sprite.scale.x = direction
	animated_sprite.play("walk")

func update(_delta: float) -> void:
	# 攻击
	if Input.is_action_just_pressed("p_combo_1"):
		switch_state.emit(combo_1_state)
		return

	# 跳跃（始终可跳，只要在地面）
	if Input.is_action_just_pressed("p_up") and character.is_on_floor():
		switch_state.emit(jump_state)
		return

	# 离开地面 → 下落
	if not character.is_on_floor():
		switch_state.emit(fall_state)
		return

	# Shift 按下 → Run
	if Input.is_action_pressed("p_run"):
		switch_state.emit(run_state)
		return

	# 无水平输入 → Idle
	if Input.get_axis("p_left", "p_right") == 0:
		switch_state.emit(idle_state)

func physics_update(_delta: float) -> void:
	var direction := Input.get_axis("p_left", "p_right")

	if direction != 0:
		character.velocity.x = direction * speed
		animated_sprite.scale.x = direction
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, speed)

	# 重力
	character.velocity.y += character.gravity * _delta
	character.move_and_slide()
