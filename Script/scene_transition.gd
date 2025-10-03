extends Node2D


func change_scene(path):
	$AnimationPlayer.play("transition")
	print(path)
	get_tree().change_scene_to_file(path)
	$AnimationPlayer.play_backwards("transition")

func transition():
	$AnimationPlayer.play("transition")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play_backwards("transition")
