extends Area2D

func _ready():
	$AnimatedSprite.play("idle")

func _on_Berry_body_entered(body):
	if "Player" in body.name:
		if body.power < body.max_power:
			body._set_power(body.max_power)
			queue_free()
