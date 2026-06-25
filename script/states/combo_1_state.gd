extends State

@export var idle_state: State
@export var walk_state: State
@export var run_state: State
@export var fall_state: State

func enter_state() -> void:
	# 攻击时锁住水平位移
	character.velocity.x = 0.0
	animated_sprite.play("combo1")

func update(_delta: float) -> void:
	# 动画播放完毕 → 回到地面状态
	if not animated_sprite.is_playing():
		if not character.is_on_floor():
			switch_state.emit(fall_state)
		elif Input.get_axis("p_left", "p_right") != 0:
			if Input.is_action_pressed("p_run"):
				switch_state.emit(run_state)
			else:
				switch_state.emit(walk_state)
		else:
			switch_state.emit(idle_state)

func physics_update(_delta: float) -> void:
	# 攻击期间水平速度归零，重力照常
	character.velocity.x = move_toward(character.velocity.x, 0.0, 5.0)
	character.velocity.y += character.gravity * _delta
	character.move_and_slide()
