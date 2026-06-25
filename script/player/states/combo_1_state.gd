extends State

@export var idle_state: State
@export var walk_state: State
@export var run_state: State
@export var fall_state: State

func enter_state() -> void:
	character.velocity.x = 0.0
	animated_sprite.play("combo1")

	# 明确变量类型，消除警告
	var direction: float = sign(animated_sprite.scale.x)
	var hitbox_shape := character.attack_hitbox.get_node("CollisionShape2D") as CollisionShape2D
	if hitbox_shape:
		hitbox_shape.position.x = 30 * direction

	character.attack_hitbox.monitoring = true

func exit_state() -> void:
	# ★ 离开攻击状态时关闭检测
	character.attack_hitbox.monitoring = false

func update(_delta: float) -> void:
	if not animated_sprite.is_playing():
		# 攻击动画结束，关闭 Hitbox（安全冗余）
		character.attack_hitbox.monitoring = false

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
	character.velocity.x = move_toward(character.velocity.x, 0.0, 5.0)
	character.velocity.y += character.gravity * _delta
	character.move_and_slide()
