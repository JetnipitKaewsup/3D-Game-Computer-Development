extends Node3D

@onready var cam: Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cam.play("Shake")
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("Scream")
	$AnimationPlayer.seek(1.0, true)
	
	await get_tree().create_timer(1.2).timeout
	get_tree().change_scene_to_file("res://Scene/died.tscn")
