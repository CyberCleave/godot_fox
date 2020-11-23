extends KinematicBody2D

const GRAVITY = 2000.0
const FLOOR = Vector2(0, -1)

export(float) var speed = 50.0
export(float) var run_mult = 3.0
export(int) var hp = 2


var vel = Vector2()
var direction = 1
var is_dead = false
var being_hit = false
var is_attacking = false
var state = WALK
var player_in_range = false

enum {
	IDLE,
	WALK,
	RUN,
	TURN,
}

func _ready():
	randomize()
	
func dead():
	hp -= 1
	if hp > 0:
		being_hit = true
		$AnimatedSprite.play("hit")
		vel.x = 0
	else:
		is_dead = true
		$CollisionShape2D.queue_free()
		vel = Vector2(0, 0)
		$AnimatedSprite.play("dead")
		$Death_Timer.start()
		
func attack():
	$AnimatedSprite.play("Attack1")
	is_attacking = true

func _physics_process(delta):
	
	if !is_dead:
		if !being_hit:
			if !is_attacking:
			
				match state:
					IDLE:
						vel.x = 0
						$AnimatedSprite.play("idle")
						if !$State_Timer.get_time_left():
							$State_Timer.start(choose([1, 0.5, 0.2]))
					WALK:
						vel.x = speed * direction
						$AnimatedSprite.play("walk")
						if is_on_wall():
							state = TURN
						if is_on_floor():
							if !$RayCast2D.is_colliding():
								state = choose([IDLE, TURN])
					RUN:
						vel.x = speed * run_mult * direction
						$AnimatedSprite.play("run")
						if is_on_wall():
							state = TURN
						if is_on_floor():
							if !$RayCast2D.is_colliding():
								state = IDLE
					TURN:
						direction = direction * -1
						$RayCast2D.position.x *= -1
						if direction == 1:
							$AnimatedSprite.flip_h = false
						else:
							$AnimatedSprite.flip_h = true
						state = WALK
							
			vel.y += GRAVITY * delta
			vel = move_and_slide(vel, FLOOR)
		
			if $RayCast2D.is_colliding():
				if $SeePlayerLeft.is_colliding():
					if direction > - 1:
						state = TURN
					else:
						if state != RUN:
							state = RUN
				if $SeePlayerRight.is_colliding():
					if direction < 0:
						state = TURN
					else:
						if state != RUN:
							state = RUN



			if get_slide_count() > 0:
				for i in range(get_slide_count()):
					if "Player" in get_slide_collision(i).collider.name:
						get_slide_collision(i).collider.hit(global_position.x)
						if !is_attacking:
							attack()


func _on_AnimatedSprite_animation_finished():
	if being_hit:
		being_hit = false
	if is_attacking:
		is_attacking = false
	

func choose(array):
	array.shuffle()
	return array.front()
	
func _on_State_Timer_timeout():
	if state == IDLE:
		if !$SeePlayerLeft.is_colliding() && !$SeePlayerRight.is_colliding() || (direction < 0 && $SeePlayerRight.is_colliding()) || (direction >= 0 && $SeePlayerLeft.is_colliding()):
			state = TURN
	
func _on_Death_Timer_timeout():
	queue_free()
