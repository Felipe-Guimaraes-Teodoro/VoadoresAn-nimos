extends RigidBody3D

@export var thrust := 0.0
@export var max_thrust := 200.0

@export var lift_power := 0.24
@export var drag := 0.02
@export var side_drag := 8.0

# o quão bom é esse trem (avião) de fazer as manobras
@export var torque_amm := 2.5

@export var yaw := 0.0
@export var pitch := 0.0
@export var roll := 0.0

@onready var engine_sound: AudioStreamPlayer3D = $propeller/Propeller

func _ready() -> void:
	add_to_group("plane")
	print("plane ready")

func _physics_process(dt: float) -> void:
	thrust = clamp(thrust, 0.0, max_thrust)
	
	if (thrust <= 0):
		engine_sound.playing = false
		if (engine_sound.playing):
			engine_sound.stop()
	else:
		if (!engine_sound.playing):
			engine_sound.play(0) 
		engine_sound.volume_db = remap(thrust, 0, 200, -80, -20)
	
	var speed = linear_velocity.length()
	
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	var up = global_transform.basis.y
	
	apply_central_force(forward * thrust)
	
	var forward_speed = forward.dot(linear_velocity)
	var lateral_speed = right.dot(linear_velocity)
	
	var local_velocity = global_transform.basis.inverse() * linear_velocity
	var angle_of_attack = -atan2(local_velocity.y, local_velocity.z)
	
	if forward_speed > 0.0:
		var lift_dir = up
		var lift_strength = calculate_lift(angle_of_attack)
		print(lift_strength)
		apply_central_force(lift_dir * lift_strength)
	
	apply_central_force(-linear_velocity * speed * drag)
	
	var side_velocity = right * linear_velocity.dot(right)
	apply_central_force(-side_velocity * side_drag)
	
	# o vetor lift já freia o avião o jogador arfar agressivamente
	
	var control = clamp(speed * 0.02, 0.0, 1.0)
	
	apply_torque(right * pitch * torque_amm * control * forward_speed)
	apply_torque(up * yaw * torque_amm * control * forward_speed)
	apply_torque(forward * roll * torque_amm * control * forward_speed)
	
	# centralizar controles
	pitch = lerp(pitch, 0.0, dt * 2.0)
	yaw = lerp(yaw, 0.0, dt * 2.0)
	roll = lerp(roll, 0.0, dt * 2.0)
	
func calculate_lift(angle_of_attack: float) -> float:
	var aoa_deg = rad_to_deg(angle_of_attack) + 14 # naturalmente um poco pra cima
	
	var lift_coefficient := 0.0
	
	#if aoa_deg < 15.0:
	lift_coefficient = aoa_deg / 15.0
	#else:
		# stall
	#	lift_coefficient = max(0.0, 1.0 - ((aoa_deg - 15.0) / 25.0))
	
	var speed = linear_velocity.length()
	return speed * speed * lift_coefficient * lift_power
