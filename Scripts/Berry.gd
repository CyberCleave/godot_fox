extends Area2D

func _ready():
	$AnimatedSprite.play("idle")

func _on_Berry_body_entered(body):
	if "Player" in body.name:
		if Global.power < Global.max_power:
			Global._set_power(Global.max_power)
			Global.berry_taken()
			queue_free()
