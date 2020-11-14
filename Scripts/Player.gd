extends KinematicBody2D


const SPEED = 250.0
const MAXSPEED = 500.0
const ACCELERATION = 0.05
const JUMPFORCE = -750.0
const GRAVITY = 2000.0
const JUMP_CUT_Y = 0.5
const JUMP_CUT_X = 0.05
const FLOOR = Vector2(0, -1)
const FIREBALL = preload("res://Scenes/Items/Fireball.tscn")
const SHOT_COST = 20
const DOUBLEJUMP_COST = 40

var player_jump = false
var can_jump = true
var is_attacking = false
var can_shoot = true
var jump_pressed = false
var jump_count = 0
var doublejump_limit = 2
var power = 100

var is_dead = false

var vel = Vector2()

func _physics_process(delta):
	
	if is_dead == false:
	
		if is_on_floor():
			if !can_jump:
				is_attacking = false
			can_jump = true
			jump_count = 0
			if jump_pressed:
				vel.y = JUMPFORCE
	
		if Input.is_action_just_pressed("player_shoot") and !is_attacking and can_shoot:
			if power >= SHOT_COST:
				if is_on_floor():
					if vel.x != 0:
						$AnimatedSprite.play("run_attack")
					else:
						$AnimatedSprite.play("attack")
				else:
					$AnimatedSprite.play("air_attack")
				is_attacking = true
				can_shoot = false
				shootTimer()
				power -= SHOT_COST
				var fireball = FIREBALL.instance()
				if sign($Position2D.position.x) == 1:
					fireball.set_fireball_direction(1)
				else:
					fireball.set_fireball_direction(-1)
				get_parent().add_child(fireball)
				fireball.position = $Position2D.global_position
				fireball.StartPosX = $Position2D.global_position.x
			else:
				print ("LOW POWER!")
	
		if Input.is_action_pressed("ui_left"):
			$AnimatedSprite.flip_h = true
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
			if vel.x >= 0:
				vel.x = -SPEED;
			if jump_count > 0:
				vel.x = max(-MAXSPEED, vel.x)
			if is_on_floor():
				vel.x = max(-MAXSPEED, vel.x - SPEED * ACCELERATION)
			if !is_attacking:
				$AnimatedSprite.play("run")
	
		if Input.is_action_pressed("ui_right"):
			$AnimatedSprite.flip_h = false
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
			if vel.x <= 0:
				vel.x = SPEED;
			if jump_count > 0:
				vel.x = min(MAXSPEED, vel.x)
			if is_on_floor():
				vel.x = min(MAXSPEED, vel.x + SPEED * ACCELERATION)
			if !is_attacking:
				$AnimatedSprite.play("run")
				
		elif (!Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right")) or (Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right")):
			if  is_on_floor():
				if !is_attacking:
					$AnimatedSprite.play("idle")
				vel.x = 0
			else:
				vel.x = lerp (vel.x, 0, JUMP_CUT_X)
		
		if Input.is_action_just_pressed("player_jump"):
			jump_pressed = true
			jump_timer()
			if can_jump:
				jump_count += 1
				vel.y = JUMPFORCE
			
		if !is_on_floor():
			coyoteTime()
			if vel.y < 0:
				if !is_attacking:
					$AnimatedSprite.play("jump")
					if Input.is_action_just_released("player_jump"):
						vel.y = vel.y * JUMP_CUT_Y
					if Input.is_action_just_pressed("player_jump"):
						print("TOO EARLY!")
			else:
				if !is_attacking:
					$AnimatedSprite.play("fall")
					if Input.is_action_just_pressed("player_jump"):
							if jump_count > 0 && jump_count < doublejump_limit:
								if vel.y < -JUMPFORCE / 2 - GRAVITY * delta:
									if power >= DOUBLEJUMP_COST:
										vel.y = JUMPFORCE
										jump_count += 1
										power -= DOUBLEJUMP_COST
										print("DOUBLE JUMP!")
									else:
										print("LOW POWER!")
								else:
									print("TOO LATE!")
							else:
								print("FALLING FROM AN EDGE OR DOUBLE JUMP LIMIT EXCEEDED!")

			if is_on_ceiling():
				vel.y = 0
				jump_pressed = false
					
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					get_slide_collision(i).collider.attack()
					dead()
				if "Spring_Shroom" in get_slide_collision(i).collider.name:
					get_slide_collision(i).collider.spring()
					spring()
	
	
	vel.y += GRAVITY * delta
		
	vel = move_and_slide(vel, FLOOR)
		
func spring():
	vel.y += JUMPFORCE
		
func dead():
	set_collision_mask(8)
	yield(get_tree().create_timer(.2), "timeout")
	set_collision_layer(0)
	vel = Vector2(0, 0)
	is_dead = true
	$AnimatedSprite.play("dead")
	$Timer.start()
	
	
func coyoteTime():
	yield(get_tree().create_timer(.02), "timeout")
	can_jump = false
	
func _on_AnimatedSprite_animation_finished():
	is_attacking = false
	
func shootTimer():
	yield(get_tree().create_timer(.5), "timeout")
	can_shoot = true
	
func jump_timer():
	yield(get_tree().create_timer(.1), "timeout")
	jump_pressed = false

func _on_Timer_timeout():
	var error_code = get_tree().change_scene("res://Scenes/Menus/TitleScreen.tscn")
	if error_code != 0:
		print("ERROR: ", error_code)
