extends State

@export var walk_state: State
@export var run_state: State
@export var jump_state: State
@export var fall_state: State
@export var combo_1_state: State

func enter_state() -> void:
	character.velocity.x = 0.0
	animated_sprite.play("idle")

func update(_delta: float) -> void:
	# 攻击
	if Input.is_action_just_pressed("p_combo_1"):
		switch_state.emit(combo_1_state)
		return

	# 离开地面 → 下落
	if not character.is_on_floor():
		switch_state.emit(fall_state)
		return

	# 跳跃
	if Input.is_action_just_pressed("p_up"):
		switch_state.emit(jump_state)
		return

	# 水平输入 → Walk 或 Run（按 Shift 时直接 Run）
	var direction := Input.get_axis("p_left", "p_right")
	if direction != 0:
		if Input.is_action_pressed("p_run"):
			switch_state.emit(run_state)
		else:
			switch_state.emit(walk_state)

func physics_update(_delta: float) -> void:
	# 重力（维持贴地）
	character.velocity.y += character.gravity * _delta
	character.move_and_slide()
