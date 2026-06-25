# ============================================================
# 状态机 - 管理 State 子节点的切换与生命周期
# ============================================================
class_name StateMachine
extends Node

@export var initial_state: State  # 初始状态（编辑器拖拽指定）

var _active_state: State          # 当前活动状态（私有）

var active_state: State:          # 对外只读
	get:
		return _active_state

func _ready() -> void:
	# 将所有子状态的切换信号连接到状态机的切换方法
	for child_state: State in get_children():
		child_state.switch_state.connect(change_state)

	# 延迟到下一帧切换，确保宿主节点的 _ready() 已完成引用注入
	if initial_state:
		call_deferred("change_state", initial_state)

# 每帧更新（输入、逻辑判断）
func _process(delta: float) -> void:
	if _active_state:
		_active_state.update(delta)

# 物理帧更新（移动、碰撞）
func _physics_process(delta: float) -> void:
	if _active_state:
		_active_state.physics_update(delta)

# 切换状态
func change_state(new_state: State) -> void:
	if new_state == _active_state:
		return  # 已处于目标状态，忽略

	# 退出旧状态
	if _active_state:
		_active_state.exit_state()

	# 记录旧状态名（仅调试）
	var old_name = _active_state.name if _active_state else "None"

	# 进入新状态
	_active_state = new_state
	if _active_state:
		_active_state.enter_state()
		print("状态切换: %s -> %s" % [old_name, _active_state.name])  # 调试日志
