extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 10.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
var player_health

const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

var camera_origin := Vector3.ZERO
var pitch = 0.0

@onready var ray_cast: RayCast3D = $Head/Camera3D/RayCast3D
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var footstep_right: AudioStreamPlayer = $footstep_right
@onready var footstep_left: AudioStreamPlayer = $footstep_left

var footstep_timer := 0.0
var footstep_interval := 0.5
var is_left_step := true


func _ready():
	player_health = 1
	camera_origin = camera.transform.origin

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#camera.current = true

func _unhandled_input(event):
	if OS.has_feature("web"):
		if event is InputEventMouseButton and event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * SENSITIVITY)
		pitch = clamp(pitch - event.relative.y * SENSITIVITY, deg_to_rad(-40), deg_to_rad(60))
		camera.rotation.x = pitch
	#if OS.has_feature("web"):
		#if event is InputEventMouseButton and event.pressed:
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#else:
		#if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			#rotate_y(-event.relative.x * SENSITIVITY)
			#pitch = clamp(pitch - event.relative.y * SENSITIVITY, deg_to_rad(-40), deg_to_rad(60))
			#camera.rotation.x = pitch

func _physics_process(delta: float) -> void:
	if ray_cast.is_colliding():
		Gamemanager.set_pnt(true)
	else:
		Gamemanager.set_pnt(false)
	
	if player_health <= 0:
		Gamemanager.update_chance(-1)
		get_tree().change_scene_to_file("res://Scene/jump_scare.tscn")
	
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.25
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	var bob_factor = 1.0
	if not is_on_floor():
		bob_factor = 0.3
	
	t_bob += delta * velocity.length() * bob_factor
	camera.transform.origin = camera_origin + _headbob(t_bob) + Vector3(0, velocity.y * 0.02, 0)
	
	move_and_slide()
	
	if direction:
		var current_speed = speed
		if Input.is_action_pressed("sprint"):
			footstep_interval = 0.3
		else:
			footstep_interval = 0.6
		
		footstep_timer -= delta
		if footstep_timer <= 0.0:
			_play_footstep()
			footstep_timer = footstep_interval
	else:
		footstep_timer = 0.0


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos


func _on_area_3d_area_entered(area) -> void:
	if area.is_in_group("Enemies"):
		player_health -= 1
		print("current player health : " + str(player_health))


func _play_footstep():
	if is_left_step:
		if not footstep_left.playing:
			footstep_left.play()
	else:
		if not footstep_right.playing:
			footstep_right.play()
	
	is_left_step = !is_left_step
