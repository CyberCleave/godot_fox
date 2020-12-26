extends Control

onready var list = $FilesList
onready var info = $InfoList
onready var hint = $Hint

func _ready():
	
	var files_array = Global.list_files_in_directory(Global.save_path)
	files_array.invert()
	for i in files_array:
		list.add_item(i)

	if list.get_item_count() > 0:
		list.select(0)
		show_info(Global.see_not_load(1))

	list.grab_focus()
	
func _on_FilesList_item_selected(index):
	show_info(Global.see_not_load(index + 1))

func _on_FilesList_item_activated(index):
	Global.load_selected(index + 1)
	
func show_info(data):
	info.clear()
	info.add_item("Level:" + str(data.level), null, false)
	info.add_item("Lives:" + str(data.lives), null, false)
	info.add_item("Power:" + str(data.power) + "/" + str(data.max_power), null, false)
	
func _physics_process(_delta):
	if Input.is_action_pressed("player_shoot"):
		var err = get_tree().change_scene("res://Scenes/Menus/TitleScreen.tscn")
		if err != OK:
			print(err)

func _on_Timer_timeout():
	hint.visible = true
