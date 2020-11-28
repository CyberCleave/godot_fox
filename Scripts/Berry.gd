extends Area2D

func _ready():
	$AnimatedSprite.play("idle")

func _on_Berry_body_entered(body):
	if "Player" in body.name:
		if PlayerData.power < PlayerData.max_power:
			PlayerData._set_power(PlayerData.max_power)
			queue_free()
