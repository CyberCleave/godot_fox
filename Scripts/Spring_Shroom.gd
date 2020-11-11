extends StaticBody2D

var springing = false

func _physics_process(_delta):
	if !springing:
		$AnimatedSprite.play("idle")

func spring():
	if !springing:
		springing = true
		$AnimatedSprite.play("Jump")
	

func _on_AnimatedSprite_animation_finished():
	springing = false
