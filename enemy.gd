extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var SPEED = 7

func _physics_process(delta):
	var current_location = global_transform.origin
	
	if !is_on_floor():
		velocity.y += delta
	
	if nav_agent.is_navigation_finished():
		velocity = Vector3.ZERO
	else:
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		velocity = velocity.move_toward(new_velocity, 0.25)
	
	move_and_slide()


func update_target_location(target_location: Vector3):
	nav_agent.set_target_position(target_location)
