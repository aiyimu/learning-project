class_name AttackHitbox
extends Area2D

## 攻击力
@export var damage: int = 1


func _ready() -> void:
	monitoring = false
	area_entered.connect(_on_area_entered)


## 激活 Hitbox（由状态机调用）
func activate() -> void:
	monitoring = true


## 停用 Hitbox
func deactivate() -> void:
	monitoring = false


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("destructible"):
		return

	if area.has_method("hit"):
		area.hit(damage)