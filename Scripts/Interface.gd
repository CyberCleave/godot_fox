extends Control

onready var life_counter = $LifeCounter/Label
onready var power_bar_under = $PowerBar/Bar_under
onready var power_bar_over = $PowerBar/Bar_over
onready var update_tween = $PowerBar/UpdateTween


export (Color) var good_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var bad_color = Color.red
export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var bad_zone = 0.3

func _ready():
	var err = Global.connect("updated", self, "update_interface")
	if err != OK:
		print(err)

	update_interface()

func update_interface():
	
	life_counter.text = str(Global.lives)
	
	power_bar_over.value = Global.power
	update_tween.interpolate_property(power_bar_under, "value", power_bar_under.value, Global.power, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()
	
	_assign_color(Global.power)
	
func _assign_color(power):
	if power < power_bar_over.max_value * bad_zone:
		power_bar_over.tint_progress = bad_color
	elif power < power_bar_over.max_value * caution_zone:
		power_bar_over.tint_progress = caution_color
	else:
		power_bar_over.tint_progress = good_color
	
func _on_max_power_updated(max_power):
	power_bar_over.max_value = max_power
	power_bar_under.max_value = max_power
