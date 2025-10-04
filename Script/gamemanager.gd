extends Node3D

var score = 0
var collected_positions: Array[Vector3] = []
var have_died = false
var mon_spawn_left = 0
var first_start = true
var finish_quest = false
var end_game_good = true

var player_chance = 3
var player_near_tree = false

var next_spawn_score = 30
var spawn_phase = 30

var play_time: float = 0.0
var is_timing: bool = false 

var curr_cutscene = "main menu"

func _process(delta: float) -> void:
	if is_timing:
		play_time += delta
		print(play_time)

func update_chance(s):
	player_chance += s

func get_chance():
	return player_chance

func update_score(amount):
	$Collect.play()
	self.score += amount
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

func set_quest_status(status):
	finish_quest = status

func get_quest_status():
	return finish_quest

func start_timer():
	is_timing = true

func stop_timer():
	is_timing = false

func reset_timer():
	play_time = 0.0

func get_time() -> float:
	return play_time

func get_time_string() -> String:
	var total_seconds = int(play_time)
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	return str(minutes) + " mins " + str(seconds) + " secs"

func set_game_result(status):
	end_game_good = status

func get_game_result():
	return end_game_good

func reset():
	score = 0
	collected_positions = []
	have_died = false
	mon_spawn_left = 0
	finish_quest = false
	end_game_good = true
	player_chance = 3
	player_near_tree = false
	next_spawn_score = 30
	spawn_phase = 30
	play_time = 0.0
	is_timing = false
	curr_cutscene = "main menu"

func set_currcutscene(name : String):
	curr_cutscene = name

func get_currcutscene():
	return curr_cutscene
