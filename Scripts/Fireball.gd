extends Area2D

export var SPEED = 800
const DISTANCE = 300.0

var vel = Vector2()
var direction = 1
var StartPosX

func _ready():
	pass
	
func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	vel.x = SPEED * delta * direction
	translate(vel)
	$AnimatedSprite.play("shoot")
	if position.x > StartPosX + DISTANCE || position.x < StartPosX - DISTANCE:
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Fireball_body_entered(body):
	if "Enemy" in body.name:
		body.dead()
	if "Box" in body.name:
		body.broken()
	queue_free()
