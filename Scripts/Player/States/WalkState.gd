extends State
class_name WalkState

@export var walk_speed := 4.0
@export var accel_time := 0.2
@export var rotation_speed := 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_name = "Walk"
	can_move = true

func enter() -> void:
	super.enter()

func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var camera: Camera3D = player.get_viewport().get_camera_3d()
	
	var forward: Vector3
	var right: Vector3
	
	if camera:
		forward = player.global_transform.basis.z
		right = player.global_transform.basis.x
	else:
		# Fallback: use player's own facing direction
		forward = player.global_transform.basis.z
		right = player.global_transform.basis.x
		
	forward.y = 0
	right.y = 0
	
	forward = forward.normalized()
	right = right.normalized()
	
	var desired_direction := (forward * input_dir.y + right * input_dir.x).normalized()
	
	if desired_direction != Vector3.ZERO:
		var accel_rate := 1.0 / accel_time if accel_time > 0 else 10.0
		var target_velocity := desired_direction * walk_speed
		
		player.velocity.x = lerp(player.velocity.x, target_velocity.x, accel_rate * delta)
		player.velocity.z = lerp(player.velocity.z, target_velocity.z, accel_rate * delta)

		var current_dir := Vector3(player.velocity.x, 0, player.velocity.z).normalized()
		if current_dir != Vector3.ZERO:
			var alignment := current_dir.dot(desired_direction)
			var turn_slowdown := 0.5 + 0.5 * alignment
			
			player.velocity.x *= turn_slowdown
			player.velocity.z += turn_slowdown
			
		var target_angle := atan2(desired_direction.x, desired_direction.z)
		var current_angle := player.rotation.y
		var angle_diff := fposmod(target_angle - current_angle + PI, TAU) - PI
		player.rotation.y += angle_diff * rotation_speed * delta
		
	else:
		var accel_rate := 1.0 / accel_time if accel_time > 0 else 10.0
		player.velocity.x = lerp(player.velocity.x, 0.0, accel_rate * delta)
		player.velocity.z = lerp(player.velocity.z, 0.0, accel_rate * delta)
		
	if not player.is_on_floor():
		player.velocity.y += player.get_player_gravity().y * delta
		
	player.move_and_slide()
