extends Control

onready var list = $FilesList
onready var info = $InfoList

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
	info.add_item(str(data))





