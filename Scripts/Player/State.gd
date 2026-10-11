extends Node
class_name State

@export var animation_name: String = ""
@export var can_move: bool = true

var state_machine: Node
var player: CharacterBody3D
var animation_tree: AnimationTree
var animation_player: AnimationNodeStateMachinePlayback
var input_controller

func enter() -> void:
	if animation_name != "" and animation_player:
		animation_player.travel(animation_name)
	
func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	pass
