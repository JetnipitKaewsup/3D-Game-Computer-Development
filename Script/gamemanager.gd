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

func _process(delta: float) -> void:
	if is_timing:
		play_time += delta

func start_timer():
	is_timing = true

func stop_timer():
	is_timing = false

func reset_timer():
	play_time = 0.0

func get_time() -> float:
	return play_time
	
func set_game_result(status):
	end_game_good = status
	
func get_game_result():
	return end_game_good

func get_time_string() -> String:
	var minutes = int(play_time) / 60
	var seconds = int(play_time) % 60
	return str(minutes).pad_zeros(2) + "mins" + str(seconds).pad_zeros(2) + "secs"

func reset():
	score = 0
	collected_positions = []
	have_died = false
	mon_spawn_left = 0
	first_start = true
	finish_quest = false
	end_game_good = true
	player_chance = 3
	player_near_tree = false
	next_spawn_score = 30
	spawn_phase = 30
	play_time = 0.0   
	is_timing = false 
