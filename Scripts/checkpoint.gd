extends Area2D

var pos = Vector2()
var do_once = false

func _ready():
	pos = global_position
	
func _on_CheckPoint_body_entered(body):
	if !do_once:
		if "Player" in body.name:
			Global.new_checkpoint(pos)
			$AnimatedSprite.play("appear")
			do_once = true
