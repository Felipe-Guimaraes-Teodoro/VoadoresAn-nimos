extends Node3D

@onready var plane = $plane/body
@onready var player = $Player
@onready var camera = $Player/Camera3D
@onready var view = $Player/Camera3D/VIEW
@onready var view_positions = [
	$plane/body/view_position,
	$plane/body/view_position2,
	$plane/body/view_position3
]
var seated: bool = false
var current_view: int = 0
var debounce := 0.0

var yaw := 0.0
var pitch := 0.0

# Caminho para o menu principal
@export_file("*.tscn") var menu_game_scene: String = "res://cenas/menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _input(event: InputEvent):
	if seated and event is InputEventMouseMotion:
		yaw -= event.relative.x * 0.002
		pitch -= event.relative.y * 0.002
		pitch = clamp(pitch, -1.5, 1.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	if debounce > 0:
		debounce-=dt
	
	# fazendo por action seria melhor
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file(menu_game_scene)
	
	if Input.is_key_pressed(KEY_E) && debounce <= 0:
		try_enter_plane()
		debounce = 0.2
		# espera um poco antes dele pode fazer outra coisa
		
	# ciclar vista
	if Input.is_physical_key_pressed(KEY_V) && debounce <= 0:
		current_view = (current_view + 1) % view_positions.size()
		debounce = 0.2
		
	if seated and Input.is_key_pressed(KEY_W):
		plane.thrust += 100 * dt;
	if seated and Input.is_key_pressed(KEY_S):
		plane.thrust -= 100 * dt;
		
	if seated and Input.is_key_pressed(KEY_A):
		plane.yaw += 100 * dt;
	if seated and Input.is_key_pressed(KEY_D):
		plane.yaw -= 100 * dt;
		
	if seated and Input.is_key_pressed(KEY_I):
		plane.pitch += 100 * dt; 
	if seated and Input.is_key_pressed(KEY_K):
		plane.pitch -= 100 * dt;
	
	if seated and Input.is_key_pressed(KEY_J):
		plane.roll -= 100 * dt; 
	if seated and Input.is_key_pressed(KEY_L):
		plane.roll += 100 * dt;
	
	if seated:
		var seat = view_positions[0]
		var view = view_positions[current_view]
		
		player.global_position = seat.global_position
		player.camera.global_position = view.global_position
		
		var rot = plane.global_transform.basis.get_euler()
		
		# model inversion fix
		rot.y += PI
		rot.x = -rot.x
		rot.z = -rot.z
		
		var q_plane = Quaternion.from_euler(rot)
		var q_yaw = Quaternion(Vector3.UP, yaw)
		var q_pitch = Quaternion(Vector3.RIGHT, pitch)
		
		var final_q = q_plane * q_yaw * q_pitch
		
		camera.global_rotation = final_q.get_euler()
		
		player.linear_velocity = Vector3.ZERO
		player.angular_velocity = Vector3.ZERO
		
		player.set_collision_layer_value(1, false)
		player.set_collision_mask_value(1, false)
		
		player.freeze = true
	else:
		player.camera.global_position = player.head.global_position
		player.set_collision_layer_value(1, true)
		player.set_collision_mask_value(1, true)
		player.freeze = false
	
	pass
	
func try_enter_plane():
	if seated == true: 
		seated = false
		return
	if view.is_colliding():
		var coll = $Player/Camera3D/VIEW.get_collider()
		if coll.is_in_group("plane"):
			seated = true
