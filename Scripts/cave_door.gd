extends Area2D

export(String, FILE, "*.tscn") var target_stage

func _ready():
	pass
	
func _on_cave_door_body_entered(body):
	if "Player" in body.name:
		body.enter_door()
		SceneChanger.change_scene(target_stage)
