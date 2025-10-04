extends Node3D

@onready var gate = $Gate/AnimationPlayer

func _ready() -> void:
	$Bad.stop()
	$Good.stop()
	Gamemanager.first_start = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Gamemanager.get_game_result():
		win()
	else:
		lose()


func win():
	$Good.play()
	print(Gamemanager.get_time_string())
	$CanvasLayer/Control/Panel/win/Time.text = Gamemanager.get_time_string()
	$CanvasLayer/Control/Panel/win/Die_frequenzy.text = str(3 - Gamemanager.player_chance)
	$CanvasLayer/Control/Panel/lose.visible = false
	$CanvasLayer/Control/Panel/win.visible = true
	$Player/AnimationPlayer.play("Run")
	$AnimationPlayer.play("win")

func lose():
	$Bad.play()
	print(Gamemanager.get_time_string())
	$AnimationPlayer2.play("Mon_run")
	$CanvasLayer/Control/Panel/lose/Die_frequenzy.text = str(3 - Gamemanager.player_chance)
	$CanvasLayer/Control/Panel/lose/Time.text = Gamemanager.get_time_string()
	$CanvasLayer/Control/Panel/lose.visible = true
	$CanvasLayer/Control/Panel/win.visible = false
	$AnimationPlayer.play("lose")
	


func _on_main_menu_pressed() -> void:
	Gamemanager.reset()
	SceneTransition.change_scene("res://Scene/main menu_LK.tscn")


	
func _on_retry_pressed() -> void:
	Gamemanager.reset()
	SceneTransition.change_scene("res://Scene/main.tscn")
