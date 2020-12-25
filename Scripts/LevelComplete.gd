extends Control

onready var berries_counter = $VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer2/Berries_Counter
onready var enemies_counter = $VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer2/Enemies_Counter
onready var secrets_counter = $VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer2/Secrets_Counter

func _ready():

	berries_counter.count = Global.level_berries
	enemies_counter.count = Global.level_enemies
	secrets_counter.count =Global.level_secrets
	
	Global.level += 1

func _physics_process(_delta):
	if Input.is_action_just_pressed("player_jump"):
		Global.save_game()
		SceneChanger.next_level()
