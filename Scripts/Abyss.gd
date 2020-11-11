extends Area2D


func _on_Abyss_body_entered(body):
	if "Player" in body.name:
		body.dead()
		get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)
