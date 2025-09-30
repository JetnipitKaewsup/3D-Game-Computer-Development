extends Node3D

@onready var player = $Player
@export var orb: PackedScene
var spawn_points: Array[Node3D] = []
@onready var camera_top: Camera3D = $CanvasLayer/Control/SubViewportContainer/SubViewport/Camera3D
@onready var minimap_frame: Panel = $CanvasLayer/Control/Minimap_frame

var danger_radius := 10.0   
var safe_radius   := 30.0

func _ready():
	for child in $orb_spawn.get_children():
		if child is Marker3D:
			print("append")
			spawn_points.append(child)
	spawn_orb()

func _physics_process(delta):
	get_tree().call_group("Enemies", "update_target_location" , player.global_transform.origin, delta)
	camera_top.position = Vector3(player.position.x, 15.0, player.position.z)
	camera_top.rotation.y = player.rotation.y
	
	_update_minimap_frame()

func spawn_orb():
	if orb and spawn_points.size() > 0:
		for spawn_point in spawn_points:
			var pos = spawn_point.global_transform.origin
			if not Gamemanager.collected_positions.any(
					func(saved_pos): return saved_pos.distance_to(pos) < 0.1):
				var new_orb = orb.instantiate()
				new_orb.global_transform.origin = pos
				add_child(new_orb)
			
func _update_minimap_frame():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	var closest_dist = INF
	for e in enemies:
		if e is Node3D:
			var dist = player.global_position.distance_to(e.global_position)
			if dist < closest_dist:
				closest_dist = dist

	# ค่าความใกล้ 0–1
	var t = clamp(1.0 - (closest_dist - danger_radius) / (safe_radius - danger_radius), 0.0, 1.0)

	if t > 0.0:
		var blink = 0.5 + 0.5 * sin(Time.get_ticks_msec() * 0.036) 
		var base_color = Color("d5153e")
		var new_color = Color.BLACK.lerp(base_color, t * blink)
		minimap_frame.modulate = new_color
	else:
		minimap_frame.modulate = Color.BLACK
