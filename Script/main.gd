extends Node3D

@export var player_scene: PackedScene
@export var orb: PackedScene
@export var Monster: PackedScene

var player: CharacterBody3D
var orb_spawn_points: Array[Node3D] = []
var player_spawn_points: Array[Node3D] = []
var Monster_spawn_points: Array[Node3D] = []

@onready var camera_top: Camera3D = $CanvasLayer/Control/SubViewportContainer/SubViewport/Camera3D
@onready var minimap_frame: Panel = $CanvasLayer/Control/Minimap_frame

var danger_radius := 10.0
var safe_radius   := 30.0


func _ready():
	Gamemanager.start_timer()
	$Ambient.play()

	for child in $orb_spawn.get_children():
		if child is Marker3D:
			orb_spawn_points.append(child)

	for child in $"Monster Spawn".get_children():
		if child is Marker3D:
			Monster_spawn_points.append(child)

	for child in $Player_Spawn.get_children():
		if child is Marker3D:
			player_spawn_points.append(child)

	spawn_player()
	spawn_orb()
	spawn_monster()


func _physics_process(delta):
	if Gamemanager.get_mon_spawn_left() > 0:
		spawn_monster()
		Gamemanager.set_mon_spawn_left(-1)

	if Gamemanager.get_pnt() && Gamemanager.get_score() >= 300:
		$"CanvasLayer/Interact Guide".visible = true
		if Input.is_action_just_pressed("Interact"):
			print("gg")
			#get_tree().change_scene_to_file("")
	else:
		$"CanvasLayer/Interact Guide".visible = false

	if Gamemanager.get_score() < 300:
		$CanvasLayer/Control/Quest1/Quest/Label/Amount.text = str(Gamemanager.get_score()) + " / 300"
		$CanvasLayer/Control/Quest1/Quest.visible = true
		$CanvasLayer/Control/Quest1/Quest2.visible = false
	elif Gamemanager.get_score() >= 300:
		if !Gamemanager.get_quest_status():
			Gamemanager.set_quest_status(true)
			$AnimationPlayer.play("krapib_quest")
			$Quest.play()
		$CanvasLayer/Control/Quest1/Quest.visible = false
		$CanvasLayer/Control/Quest1/Quest2.visible = true

	get_tree().call_group("Enemies", "update_target_location", player.global_transform.origin, delta)

	camera_top.position = Vector3(player.position.x, 40.0, player.position.z)
	camera_top.rotation.y = player.rotation.y

	_update_minimap_frame()


func spawn_orb():
	if orb and orb_spawn_points.size() > 0:
		for spawn_point in orb_spawn_points:
			var pos = spawn_point.global_transform.origin
			if not Gamemanager.collected_positions.any(
				func(saved_pos):
					return saved_pos.distance_to(pos) < 0.1
			):
				var new_orb = orb.instantiate()
				new_orb.global_transform.origin = pos
				add_child(new_orb)


func spawn_player():
	if player_scene and player_spawn_points.size() > 0:
		var random_index = randi() % player_spawn_points.size()
		var spawn_point = player_spawn_points[random_index]
		player = player_scene.instantiate()
		player.global_transform.origin = spawn_point.global_transform.origin
		add_child(player)


func spawn_monster():
	if Monster and Monster_spawn_points.size() > 0 and player:
		var candidates: Array = []
		for spawn_point in Monster_spawn_points:
			if player.global_position.distance_to(spawn_point.global_position) > 10.0: # อย่างน้อยห่าง 10 เมตร
				candidates.append(spawn_point)

		if candidates.size() > 0:
			var spawn_point = candidates[randi() % candidates.size()]
			var new_monster = Monster.instantiate()
			new_monster.global_position = spawn_point.global_position
			add_child(new_monster)
			print("spawn at:", new_monster.global_position)


func _update_minimap_frame():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	var closest_dist = INF

	for e in enemies:
		if e is Node3D:
			var dist = player.global_position.distance_to(e.global_position)
			if dist < closest_dist:
				closest_dist = dist

	# ค่าความใกล้ 0–1
	var t = clamp(1.0 - (closest_dist - danger_radius) / (safe_radius - danger_radius),0.0,1.0)

	if t > 0.0:
		var blink = 0.5 + 0.5 * sin(Time.get_ticks_msec() * 0.036)
		var base_color = Color("d5153e")
		var new_color = Color.BLACK.lerp(base_color, t * blink)
		minimap_frame.modulate = new_color
	else:
		minimap_frame.modulate = Color.BLACK
