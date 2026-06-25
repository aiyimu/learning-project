extends CharacterBody2D

@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_hitbox: Area2D = $AttackHitbox

@export var gravity: float = 980.0
@export var jump_velocity: float = -400.0
 
func _ready() -> void:
	# 攻击 Hitbox 默认关闭
	attack_hitbox.monitoring = false

	for state: State in state_machine.get_children():
		state.character = self
		state.animated_sprite = animated_sprite

func push_crates(push_velocity: Vector2) -> void:
	# 如果推动速度太小则不处理
	if push_velocity.length() < 0.1:
		return

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		# Crate 现在直接是 RigidBody2D 根节点，无需再查 parent
		if collider is Crate and not collider.is_broken:
			var target_velocity = Vector2(push_velocity.x, 0) * 0.9
			
			# 射线检测：箱子前方是否有墙壁，防止玩家被夹在箱子与墙壁之间
			var space_state := get_world_2d().direct_space_state
			var query := PhysicsRayQueryParameters2D.create(
				collider.global_position,
				collider.global_position + Vector2(sign(push_velocity.x) * 20, 0),
				1  # 只检测墙壁层（TileMapLayer 默认 layer 1）
			)
			query.exclude = [collider, self]
			var result := space_state.intersect_ray(query)
			
			if result:
				# 箱子前方被墙壁挡住，停止推动
				collider.linear_velocity = Vector2.ZERO
			else:
				collider.linear_velocity = target_velocity
