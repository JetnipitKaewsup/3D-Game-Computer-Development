extends Node3D

var score = 0
var collected_positions: Array[Vector3] = []

func update_score(score):
	score += score
