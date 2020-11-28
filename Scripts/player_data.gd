extends Node

signal updated

var max_lives = 99
var max_power = 100
onready var power = max_power setget _set_power
onready var lives = 99 setget _set_lives

func reset():
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
	
	
	

