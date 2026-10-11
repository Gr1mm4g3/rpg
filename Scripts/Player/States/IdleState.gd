extends State
class_name IdleState

@export var friction: float = 12.0
@export var floor_snap_length: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_name = "Idle"
	can_move = true

func enter() -> void:
	super.enter()

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += player.get_player_gravity().y * delta
	else:
		player.velocity.y = -floor_snap_length
		
	# Decelerate horizontal movement
	player.velocity.x = lerp(player.velocity.x, 0.0, friction * delta)
	player.velocity.z = lerp(player.velocity.z, 0.0, friction * delta)
	
	player.move_and_slide()
