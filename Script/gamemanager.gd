extends Node3D

var score = 0
var collected_positions: Array[Vector3] = []
var have_died = false
var mon_spawn_left = 0

var player_chance = 3
var player_near_tree = false

var next_spawn_score = 30
var spawn_phase = 30

func update_chance(s):
	player_chance += s

func get_chance():
	return player_chance

func update_score(score):
	self.score += score
	if self.score >= next_spawn_score:
		mon_spawn_left += 1
		print("mon spawn : " + str(mon_spawn_left))
		print("add mon")
		next_spawn_score += spawn_phase

func get_score():
	return score

func get_status():
	return have_died

func set_status(status):
	have_died = status

func set_pnt(status):
	player_near_tree = status
	
func get_pnt():
	return player_near_tree

func get_mon_spawn_left():
	return mon_spawn_left

func set_mon_spawn_left(amount):
	mon_spawn_left += amount
