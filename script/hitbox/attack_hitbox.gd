class_name AttackHitbox
extends Area2D

## 攻击力
@export var damage: int = 1


func _ready() -> void:
	monitoring = false
	collision_layer = 0  # 默认不在任何碰撞层，其他 Area2D 检测不到
	area_entered.connect(_on_area_entered)


## 获取攻击力（供 Crate 等被攻击对象查询）
func get_damage() -> int:
	return damage


## 激活 Hitbox（由状态机调用）
func activate() -> void:
	monitoring = true
	collision_layer = 8  # 放入攻击层，可被 HitArea 检测到
	
	# 立即检测已重叠的 Crate（处理玩家站着不动攻击的场景）
	# get_overlapping_bodies 通过 collision_mask 筛选，Crate 的 RigidBody2D 在 layer 1
	for body in get_overlapping_bodies():
		if body is Crate and not body.is_broken:
			body.hit(damage)


## 停用 Hitbox
func deactivate() -> void:
	monitoring = false
	collision_layer = 0  # 移除碰撞层，不再被任何 Area2D 检测到


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("destructible"):
		return

	if area.has_method("hit"):
		area.hit(damage)