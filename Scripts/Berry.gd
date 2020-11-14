extends Area2D

func _ready():
	$AnimatedSprite.play("idle")

func _on_Berry_body_entered(body):
	if "Player" in body.name:
		if body.power < 100:
			body.power = 100
			queue_free()
