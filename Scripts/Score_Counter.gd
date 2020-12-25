extends Control

export (int) var count

onready var show_dozens = $HBoxContainer/Dozens_Control/Dozens
onready var show_units = $HBoxContainer/Units_Control/Units

func _ready():
	pass
		
func _physics_process(_delta):
	
	count = clamp(count, 0, 99)
	
	if count < 10:
		show_dozens.get_parent().visible = false
	else:
		show_dozens.get_parent().visible = true
	
	var temp_count
	
	if temp_count != count:
		if count < 10:
			show_units.set_frame(count)
		else:
			var count_string = str(count)
			var units = int(count_string[1])
			var dozens = int(count_string[0])
			show_units.set_frame(units)
			show_dozens.set_frame(dozens)
		
		temp_count = count
