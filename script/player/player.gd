extends CharacterBody2D

@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var gravity: float = 980.0
@export var jump_velocity: float = -400.0

func _ready() -> void:
	for state: State in state_machine.get_children():
		state.character = self
		state.animated_sprite = animated_sprite
