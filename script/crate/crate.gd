class_name Crate
extends Area2D

@export var hp: int = 1
@export var drop_scene: PackedScene
@export var break_duration: float = 0.3

# 物理阻挡体（现在作为兄弟节点引用）
@onready var block_body: RigidBody2D = $RigidBody2D
@onready var sprite: Sprite2D = $"Sprite2D"
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var particles: CPUParticles2D = $CPUParticles2D
var is_broken: bool = false

func _ready() -> void:
	add_to_group("destructible")

func hit(damage: int = 1) -> void:
	if is_broken:
		return
	hp -= damage
	if hp <= 0:
		break_apart()
	else:
		modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(0.1).timeout
		modulate = Color.WHITE

func break_apart() -> void:
	is_broken = true
	collision.set_deferred("disabled", true)
	
	# 安全地禁用物理体碰撞层
	if block_body:
		block_body.collision_layer = 0

	if particles:
		particles.emitting = true

	if drop_scene:
		var drop = drop_scene.instantiate()
		drop.global_position = global_position
		get_parent().add_child(drop)

	var tween := create_tween()
	tween.tween_property(sprite, "scale", Vector2.ZERO, break_duration)
	tween.tween_callback(_destroy_crate)

func _destroy_crate() -> void:
	# 删除物理体（如果有）以及自身，而不是删除父节点
	if block_body:
		block_body.queue_free()
	queue_free()
