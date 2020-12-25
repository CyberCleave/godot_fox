extends CanvasLayer

const LEVELS_PATH = "res://Scenes/Levels/Level" 

onready var animation_player = $AnimationPlayer
onready var black = $Control/Black

func next_level():
	var next_level = LEVELS_PATH + str(Global.level) + ".tscn"
	change_scene(next_level)

func change_scene(path):
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	var err = get_tree().change_scene(path)
	if err != OK:
		print(err)
	animation_player.play_backwards("fade")
	yield(animation_player, "animation_finished")

