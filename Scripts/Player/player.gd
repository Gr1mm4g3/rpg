extends CharacterBody3D

@export var gravity: float = -20.0
@export var max_stamina: float = 100.0
@export var stamina_regen_rate: float = 15.0

var paused: bool = false
var stamina: float = 100.0
var invincible: bool = false

@onready var state_machine: Node = $StateMachine

func _ready() -> void:
	stamina = max_stamina

func get_player_gravity() -> Vector3:
	return Vector3(0, gravity, 0)
	
func _process(delta: float) -> void:
	if state_machine and state_machine.get("current_state"):
		if state_machine.current_state.name != "RunState":
			stamina = min(stamina + stamina_regen_rate * delta, max_stamina)
