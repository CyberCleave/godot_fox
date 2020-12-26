extends Node

signal updated

var level = 1
var start_lives = 3
var max_lives = 99
var max_power = 100

var level_berries = 0
var level_enemies = 0
var level_secrets = 0

var global_berries = 0
var global_enemies = 0
var global_secrets = 0

onready var power = max_power setget _set_power
onready var lives = start_lives setget _set_lives

var checkpoint_pos = Vector2()

var save_path = "user://save"


#-----------------------------------new game------------------------------------


func new_game():
	
	level = 1
	start_lives = 3
	max_power = 100

	level_berries = 0
	level_enemies = 0
	level_secrets = 0

	global_berries = 0
	global_enemies = 0
	global_secrets = 0

	_set_power(100)
	_set_lives(3)
	
	checkpoint_pos = Vector2()


#--------------------------character stats management---------------------------


func power_reset():
	power = max_power
	emit_signal("updated")
	
func set_max_power(new_max_power):
	max_power = new_max_power
	emit_signal("updated")
	
func _set_power(value):
	var prev_power = power
	power = clamp(value, 0, max_power)
	if power != prev_power:
		emit_signal("updated")
		
func _set_lives(value):
	var prev_lives = lives
	lives = clamp(value, 0, max_lives)
	if lives != prev_lives:
		emit_signal("updated")
		
func new_checkpoint(check_pos):
	checkpoint_pos = check_pos


#--------------------------achievements management------------------------------


func berry_taken():
	level_berries += 1
	global_berries += 1
	
func enemy_down():
	level_enemies += 1
	global_enemies += 1
	
func secret_found():
	level_secrets += 1
	global_secrets += 1


#--------------------------current date and time--------------------------------


func get_date_time():
	var time = OS.get_datetime()
	var time_return = String(time.year) + "-" + String(time.month) + "-" + String(time.day) + "_" + String(time.hour) +"-"+String(time.minute)+"-"+String(time.second)
	return time_return


#---------------------------------saving----------------------------------------


func save_game():
	var data = {
		"power" : power,
		"max_power" : max_power,
		"lives" : lives,
		"level": level,
		"checkpoint_pos" : checkpoint_pos,
		"global_berries": global_berries,
		"global_enemies": global_enemies,
		"global_secrets": global_secrets
	}
	
	var dir = Directory.new()
	if !dir.dir_exists(save_path):
		dir.make_dir(save_path)
		
	var file_name = save_path.plus_file(get_date_time() + ".dat")

	var file = File.new()
	var err = file.open(file_name, File.WRITE)
	if err == OK:
		file.store_var(data)
		file.close()


#--------------------------------loading---------------------------------------


func countinue():
	var path_to_load = save_path.plus_file(list_files_in_directory(save_path).back())
	print(path_to_load)
	load_game(path_to_load)
	
func load_selected(index):
	var path_to_load = save_path.plus_file(list_files_in_directory(save_path)[-index])
	print(path_to_load)
	load_game(path_to_load)
	
func load_game(path_to_load):
	var file = File.new()
	if file.file_exists(path_to_load):
		var err = file.open(path_to_load, File.READ)
		if err == OK:
			var player_data = file.get_var()
			file.close()
			
			power = player_data.power
			max_power = player_data.max_power
			lives = player_data.lives
			level = player_data.level
			global_berries = player_data.global_berries
			global_enemies = player_data.global_enemies
			global_secrets = player_data.global_secrets

			SceneChanger.next_level()
			
func see_not_load(index):
	var path_to_load = save_path.plus_file(list_files_in_directory(save_path)[-index])
	print(path_to_load)
	var file = File.new()
	if file.file_exists(path_to_load):
		var err = file.open(path_to_load, File.READ)
		if err == OK:
			var player_data = file.get_var()
			file.close()
			return player_data
		else:
			return err

#----------------------------List Directory-------------------------------------


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true, true)

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if file.ends_with(".dat"):
				files.append(file)

	dir.list_dir_end()

	return files
