class_name State
extends Node

signal switch_state(state: State)

var character: CharacterBody2D
var animated_sprite: AnimatedSprite2D

func enter_state() -> void:
	pass

func exit_state() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
