extends Node2D



func _ready() -> void:
	$AnimationPlayer.play("Fade")
	
	if Gamemanager.get_chance() > 0:
		await get_tree().create_timer(4).timeout
		get_tree().change_scene_to_file("res://Scene/died_continue.tscn")
	elif Gamemanager.get_chance() <= 0 :
		Gamemanager.set_currcutscene("bad ending")
		get_tree().change_scene_to_file("res://Scene/main menu_LK.tscn")
