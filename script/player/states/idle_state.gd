extends State

@export var walk_state: State
@export var run_state: State
@export var jump_state: State
@export var fall_state: State
@export var combo_1_state: State

# 可导出的土狼时间（秒），可根据手感微调
@export var coyote_duration: float = 0.25

# 离地计时器
var off_floor_timer: float = 0.0

func enter_state() -> void:
	character.velocity.x = 0.0
	animated_sprite.play("idle")
	# 进入 idle 时重置计时器（通常落地时进入 idle，所以认为在地面）
	off_floor_timer = 0.0

func update(_delta: float) -> void:
	# 1. 攻击
	if Input.is_action_just_pressed("p_combo_1"):
		switch_state.emit(combo_1_state)
		return

	# 2. 跳跃
	# 条件：按下跳跃键，并且（在地面 或 离地时间 < 阈值）
	if Input.is_action_just_pressed("p_up") and (character.is_on_floor() or off_floor_timer < coyote_duration):
		switch_state.emit(jump_state)
		return   # 已处理跳跃，不再执行后续状态切换

	# 3. 下落
	# 如果离地时间已经超过阈值，且没有触发跳跃，则进入下落状态
	if off_floor_timer >= coyote_duration and not character.is_on_floor():
		switch_state.emit(fall_state)
		return

	# 4. 水平移动
	var direction := Input.get_axis("p_left", "p_right")
	if direction != 0:
		if Input.is_action_pressed("p_run"):
			switch_state.emit(run_state)
		else:
			switch_state.emit(walk_state)

func physics_update(_delta: float) -> void:
	# 应用重力并移动
	character.velocity.y += character.gravity * _delta
	character.move_and_slide()

	# 更新离地计时器
	if character.is_on_floor():
		off_floor_timer = 0.0          # 在地面时重置计时器
	else:
		off_floor_timer += _delta      # 离地则累加时间
