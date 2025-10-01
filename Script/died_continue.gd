extends Node2D

var choose = 1

@onready var choose_1: Sprite2D = $CanvasLayer/Control/Panel/Choose1
@onready var choose_2: Sprite2D = $CanvasLayer/Control/Panel/Choose2

@onready var current_chance: Label = $"CanvasLayer/Control/current chance"
@onready var last_chance: Label = $"CanvasLayer/Control/Last Chance"
@onready var current_chance_text: Label = $CanvasLayer/Control/Label
@onready var skull: Sprite2D = $"CanvasLayer/Control/Skull-removebg-preview"


func _ready() -> void:
	choose = 1
	choose_1.visible = true
	choose_2.visible = false

func _process(delta: float) -> void:
	if Gamemanager.get_chance() > 1:
		skull.modulate = Color("ffffff")
		current_chance.visible = true
		current_chance_text.visible = true
		last_chance.visible = false
		current_chance.text = str(Gamemanager.get_chance())
	elif Gamemanager.get_chance() == 1:
		skull.modulate = Color("e80038")
		current_chance.visible = false
		current_chance_text.visible = false
		last_chance.visible = true
	if Input.is_action_just_pressed("move_forward") && choose == 2:
		choose = 1
		choose_1.visible = true
		choose_2.visible = false
		print('1')
	if Input.is_action_just_pressed("move_back") && choose == 1:
		choose = 2
		choose_1.visible = false
		choose_2.visible = true
		await  get_tree().create_timer(1).timeout
		print('2')
		
	if Input.is_action_just_pressed("Enter"):
		if choose == 1:
			get_tree().change_scene_to_file("res://Scene/main.tscn")
		elif choose == 2 :
			get_tree().change_scene_to_file("res://Scene/main menu_LK.tscn")
