extends RigidBody3D

@export var sensitivity := 0.002
@export var speed := 5.0
@export var jump_force := 1.0
@onready var ground_ray: RayCast3D = $RayCast3D
@onready var camera: Camera3D = $Camera3D

var grounded := false
var yaw := 0.0
var pitch := 0.0

func _ready() -> void:
	axis_lock_angular_x = true
	axis_lock_angular_z = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	can_sleep = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(dt: float) -> void:
	rotation.y = yaw
	camera.rotation.x = pitch
	
	grounded = ground_ray.is_colliding()
	
	var basis = Basis(Vector3.UP, yaw)
	var forward = -basis.z
	var right = basis.x
	
	var wishdir = Vector3.ZERO
	
	if Input.is_key_pressed(KEY_W):
		wishdir += forward
	if Input.is_key_pressed(KEY_S):
		wishdir -= forward
	if Input.is_key_pressed(KEY_D):
		wishdir += right
	if Input.is_key_pressed(KEY_A):
		wishdir -= right
	
	wishdir = wishdir.normalized()
	
	move_and_collide(wishdir*dt*speed)
	
	if Input.is_key_pressed(KEY_SPACE) and grounded:
		apply_central_impulse(Vector3.UP * jump_force)
	
