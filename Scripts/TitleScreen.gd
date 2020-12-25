extends Control

onready var Continue = $VBoxContainer/HBoxContainer/VBoxContainer/Continue
onready var New = $VBoxContainer/HBoxContainer/VBoxContainer/New
onready var Load = $VBoxContainer/HBoxContainer/VBoxContainer/Load
onready var Exit = $VBoxContainer/HBoxContainer/VBoxContainer/Exit

func _ready():
	
	if !Global.list_files_in_directory(Global.save_path).empty():
		Continue.visible = true
		Load.visible = true
		Continue.grab_focus()
	else:
		Continue.visible = false
		Load.visible = false
		New.grab_focus()
	
func _physics_process(_delta):
	if Continue.is_hovered():
		Continue.grab_focus()
	if New.is_hovered():
		New.grab_focus()
	if Load.is_hovered():
		Load.grab_focus()
	if Exit.is_hovered():
		Exit.grab_focus()


#-------------------------------buttons pressed---------------------------------


func _on_New_pressed():
	Global.new_game()
	SceneChanger.next_level()

func _on_Exit_pressed():
	get_tree().quit()

func _on_Load_pressed():
	var err = get_tree().change_scene("res://Scenes/Menus/Load_Menu.tscn")
	if err != OK:
		print(err)

func _on_Continue_pressed():
	Global.countinue()
