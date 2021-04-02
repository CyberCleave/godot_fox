extends Node2D

export (int) var limit

func _on_Area2D_body_entered(body):
		if "Player" in body.name:
			body.get_node("Camera2D").limit_bottom = limit

