extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@export var SPEED = 7.0
@export var ACCELERATION = 10.0  
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")


var last_target_pos: Vector3 = Vector3.ZERO
var update_timer := 0.0
var UPDATE_INTERVAL := 0.2  

func _physics_process(delta):
	var current_location = global_transform.origin

	if !is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0

	if nav_agent.is_navigation_finished():
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION * delta)
	else:
		var next_location = nav_agent.get_next_path_position()
		var direction = (next_location - current_location).normalized()
		var target_velocity = direction * SPEED
		velocity.x = move_toward(velocity.x, target_velocity.x, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, ACCELERATION * delta)

	# >>> หันไปทิศทางการเคลื่อนที่ <<<
	if velocity.length() > 0.1:
		var facing = Vector3(velocity.x, 0, velocity.z).normalized()
		var target_rot = atan2(facing.x, facing.z)
		rotation.y = lerp_angle(rotation.y, target_rot, 5.0 * delta)

	move_and_slide()

	if get_tree().get_current_scene():
		var player = get_tree().current_scene.get_node_or_null("Player")
		if player:
			update_target_location(player.global_transform.origin, delta)

func update_target_location(target_location: Vector3, delta: float):
	update_timer -= delta
	if update_timer <= 0.0:
		if last_target_pos.distance_to(target_location) > 0.5:
			nav_agent.set_target_position(target_location)
			last_target_pos = target_location
		update_timer = UPDATE_INTERVAL
