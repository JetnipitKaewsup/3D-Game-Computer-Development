extends Node3D

@onready var player = $Player
@export var orb: PackedScene
var spawn_points: Array[Node3D] = []


func _ready():
	for child in $orb_spawn.get_children():
		if child is Marker3D:
			print("append")
			spawn_points.append(child)
	spawn_orb()

func _physics_process(delta):
	get_tree().call_group("Enemies", "update_target_location" , player.global_transform.origin)

func spawn_orb():
	if orb and spawn_points.size() > 0:
		for spawn_point in spawn_points:
			var new_orb = orb.instantiate()
			new_orb.global_transform.origin = spawn_point.global_transform.origin
			add_child(new_orb)
			print("add :", new_orb.global_transform.origin)
