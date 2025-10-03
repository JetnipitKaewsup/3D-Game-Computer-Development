extends Node3D



#AnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gate = $Gate/AnimationPlayer
@onready var tree = $Tree/AnimationPlayer
@onready var player = $playerCutscene/AnimationPlayer
@onready var bee = $Armabee/AnimationPlayer

#Camera
@onready var camera_1: Camera3D = $Camera1
@onready var camera_2: Camera3D = $Camera2
@onready var front: Camera3D = $playerCutscene/front
@onready var view_4: Camera3D = $view4

@onready var ani_chars := {
	"player": player,
	"tree": tree,
	"gate": gate,
	"bee" : bee
}
func _ready() -> void:
	#camera_1.current = false
	#camera_2.current = false
	#front.current = false
	#view_4.current = false
	print("eiei")
	print(Gamemanager.get_currcutscene())
	if Gamemanager.get_currcutscene() == "main menu":
		animation_player.play("main menu")
	if Gamemanager.get_currcutscene() == "sacred tree":
		animation_player.play("sacred tree")
		await animation_player.animation_finished
		SceneTransition.change_scene("res://Scene/main.tscn")
	if Gamemanager.get_currcutscene() == "bad ending":
		animation_player.play("bad ending")	
		await animation_player.animation_finished
		SceneTransition.change_scene("res://Scene/conclusion_scene.tscn")
	if Gamemanager.get_currcutscene() == "good ending":
		animation_player.play("good ending")	
		await animation_player.animation_finished
		SceneTransition.change_scene("res://Scene/conclusion_scene.tscn")
	#animation_player.play("cutscene")
	


func gate_open():
	gate.play("open")

func gate_close():
	gate.play_backwards("open")

func switch_camera (i : int):
	if (i == 1) :
		camera_1.current = true
	if (i == 2) :
		camera_2.current = true
	if (i == 3) :
		front.current = true
	if (i == 4) :
		view_4.current = true
		
func playAni(CharName :String, AniName : String , loop : bool):
	var ani_char : AnimationPlayer = ani_chars.get(CharName,null)
	if ani_char == null:
		print("No AnimationPlayer found for ", CharName)
		return
	var anim = ani_char.get_animation(AniName)
	if anim == null:
		print("Animation not found: ", AniName)
		return
	else :
		if loop:
			anim.loop_mode = Animation.LOOP_LINEAR
		else : 
			anim.loop_mode = Animation.LOOP_NONE
	ani_char.play(AniName)
	
func playback(CharName :String, AniName : String , loop : bool):
	var ani_char : AnimationPlayer = ani_chars.get(CharName,null)
	if ani_char == null:
		print("No AnimationPlayer found for ", CharName)
		return
	var anim = ani_char.get_animation(AniName)
	if anim == null:
		print("Animation not found: ", AniName)
		return
	else :
		if loop:
			anim.loop_mode = Animation.LOOP_LINEAR
		else : 
			player.get_animation(AniName).loop_mode = Animation.LOOP_LINEAR
	ani_char.play_backwards(AniName)

func pause(CharName :String):
	var ani_char : AnimationPlayer = ani_chars.get(CharName,null)
	ani_char.pause()


func play(CharName : String):
	var ani_char : AnimationPlayer = ani_chars.get(CharName,null)
	ani_char.play()
	

func off_fog():
	$WorldEnvironment.environment.fog_enabled = false


func _on_start_button_pressed() -> void:
	print("start")
	animation_player.play("warning")
	await animation_player.animation_finished
	animation_player.play("cutscene")
	await animation_player.animation_finished
	SceneTransition.change_scene("res://Scene/main.tscn")


func play_cutscene(cutscene_name):
	SceneTransition.change_scene("res://Scene/main menu_LK.tscn")
	if !cutscene_name == "give up":
		animation_player.play(cutscene_name)
	else :
		animation_player.seek(23.0)
		animation_player.play("main menu")
		
