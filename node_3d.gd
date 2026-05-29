extends Node3D

@onready var plane = $plane/body
@onready var player = $Player
@onready var camera = $Player/Camera3D
@onready var view = $Player/Camera3D/VIEW
var seated: bool = false

# Caminho para o menu principal
@export_file("*.tscn") var menu_game_scene: String = "res://menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file(menu_game_scene)
	
	if Input.is_key_pressed(KEY_E):
		try_enter_plane()
		
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
		var seat = $plane/body/view_position
		
		player.global_transform = seat.global_transform
		
		player.linear_velocity = Vector3.ZERO
		player.angular_velocity = Vector3.ZERO
		
		player.set_collision_layer_value(1, false)
		player.set_collision_mask_value(1, false)
		
		player.freeze = true
	else:
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
