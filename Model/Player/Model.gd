extends Node3D

func run(status):
	if status:
		$AnimationPlayer.play("Run")
	else:
		$AnimationPlayer.play("Idle")
