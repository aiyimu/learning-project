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
