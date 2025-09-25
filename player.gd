extends CharacterBody3D

var speed 
const WALK_SPEED = 5.0
const SPRINT_SPEED = 10.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

# bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

var camera_origin := Vector3.ZERO
var pitch = 0.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var camera_top: Camera3D = $SubViewportContainer/SubViewport/Camera3D


func _ready():
	# ถ้าเล่นบน Web ให้โชว์ cursor ไว้ก่อน (เพราะ browser ต้องการ user interaction)
	if OS.has_feature("web"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	# --- จัดการ lock mouse บน Web ---
	if OS.has_feature("web"):
		if event is InputEventMouseButton and event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# --- หมุนกล้อง ---
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		pitch = clamp(pitch - event.relative.y * SENSITIVITY, deg_to_rad(-40), deg_to_rad(60))
		camera.rotation.x = pitch


func _physics_process(delta: float) -> void:
	# อัพเดตตำแหน่งกล้องบน minimap
	camera_top.position = Vector3(position.x, 15.0, position.z)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.25

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Sprint / Walk
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Movement
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	# Head bob
	var bob_factor = 1.0
	if not is_on_floor():
		bob_factor = 0.3
	t_bob += delta * velocity.length() * bob_factor
	
	camera.transform.origin = camera_origin + _headbob(t_bob) + Vector3(0, velocity.y * 0.02, 0)

	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
