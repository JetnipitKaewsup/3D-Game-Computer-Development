extends Node3D



#AnimationPlayer
@onready var gate = $Gate/AnimationPlayer
@onready var tree = $Tree/AnimationPlayer
@onready var player = $playerCutscene/AnimationPlayer
@onready var bee = $Armabee/AnimationPlayer

#Camera
@onready var camera_1: Camera3D = $Camera1
@onready var camera_2: Camera3D = $Camera2

@onready var ani_chars := {
	"player": player,
	"tree": tree,
	"gate": gate,
	"bee" : bee
}
func _ready() -> void:
	$AnimationPlayer.play("main menu")
	
	
func gate_open():
	gate.play("open")

func gate_close():
	gate.play_backwards("open")

func switch_camera (i : int):
	if (i == 1) :
		camera_1.current = true
	if (i == 2) :
		camera_2.current = true
		


#func playAni(char_name: String, ani_name: String, loop: bool):
	#var anim_player: AnimationPlayer = anim_players.get(char_name,null)
	#if anim_player == null:
		#return
	#if anim_player:
		#var anim = anim_player.get_animation(ani_name)
		#if anim:
			#anim.loop = loop
		#anim_player.play(ani_name)
		
func playAni(CharName :String, AniName : String , loop : bool):
	#var ani_char : AnimationPlayer = ani_chars.get(CharName)
	#var char = ani_char.get_animation(AniName)
	#if loop:
		#char.loop_mode = Animation.LOOP_LINEAR
	#ani_char.play(AniName)
	#if CharName == "player":
		#if loop :
			#player.get_animation(AniName).loop_mode = Animation.LOOP_LINEAR
		#else : 
			#player.get_animation(AniName).loop_mode = Animation.LOOP_LINEAR
		#player.play(AniName)
		#
	#elif (CharName == "tree"):
		#tree.get_animation(AniName).loop = loop
		#tree.play(AniName)
		#
	#elif (CharName == "gate"):
		#gate.get_animation(AniName).loop = loop
		#gate.play(AniName)
	#elif (CharName == "bee"):
		#bee.get_animation(AniName).loop = loop
		#bee.play(AniName)
		
	
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
	ani_char.play(AniName)
func pause(CharName :String):
	var ani_char : AnimationPlayer = ani_chars.get(CharName,null)
	ani_char.pause()
	#if CharName == "player":
		##player.get_animation(AniName).loop = loop
		#player.pause()
		#
	#elif (CharName == "tree"):
		##tree.get_animation(AniName).loop = loop
		#tree.pause()
		#
	#elif (CharName == "gate"):
		##gate.get_animation(AniName).loop = loop
		#gate.pause()

func play(CharName : String):
	var ani_char : AnimationPlayer = ani_chars.get(CharName,null)
	ani_char.play()
	#if CharName == "player":
		##player.get_animation(AniName).loop = loop
		#player.play()
		#
	#elif (CharName == "tree"):
		##tree.get_animation(AniName).loop = loop
		#tree.play()
		#
	#elif (CharName == "gate"):
		##gate.get_animation(AniName).loop = loop
		#gate.play()

func off_fog():
	$WorldEnvironment.environment.fog_enabled = false


func _on_start_button_pressed() -> void:
	pass
	#get_tree().change_scene_to_file("")
	
