class_name Crate
extends RigidBody2D

@export var hp: int = 1
@export var drop_scene: PackedScene
@export var break_duration: float = 0.3

@onready var hit_area: Area2D = $HitArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $CPUParticles2D
var is_broken: bool = false
var _last_hit_frame: int = -1

func _ready() -> void:
	add_to_group("destructible")
	hit_area.area_entered.connect(_on_hit_area_entered)

func _on_hit_area_entered(area: Area2D) -> void:
	if area.has_method("get_damage"):
		hit(area.get_damage())
	else:
		hit(1)

func hit(damage: int = 1) -> void:
	if is_broken:
		return
	# 防止同一物理帧内被多次命中（get_overlapping_bodies + area_entered 双触发）
	if _last_hit_frame == Engine.get_physics_frames():
		return
	_last_hit_frame = Engine.get_physics_frames()
	
	hp -= damage
	if hp <= 0:
		break_apart()
	else:
		modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(0.1).timeout
		modulate = Color.WHITE

func break_apart() -> void:
	is_broken = true
	
	# 禁用物理碰撞
	collision_layer = 0
	collision_mask = 0
	# 禁用攻击检测
	hit_area.set_deferred("monitoring", false)
	hit_area.set_deferred("monitorable", false)

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
	queue_free()
