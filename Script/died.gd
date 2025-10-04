extends Node2D



func _ready() -> void:
	$AnimationPlayer.play("Fade")
	
	if Gamemanager.get_chance() > 0:
		await get_tree().create_timer(4).timeout
		SceneTransition.change_scene("res://Scene/died_continue.tscn")
	elif Gamemanager.get_chance() <= 0 :
		await get_tree().create_timer(4).timeout
		Gamemanager.set_currcutscene("bad ending")
		Gamemanager.set_game_result(false)
		SceneTransition.change_scene("res://Scene/main menu_LK.tscn")
