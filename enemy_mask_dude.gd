extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 90
const JUMP_POWER = -700
var N_JUMPS = 1

func _ready():
	$AnimatedSprite2D.play("Idle")
	
func near_player():
	return $Near.is_colliding()
	
func see_player():
	return $Right.is_colliding()
	
func move():
	velocity.x = SPEED
	$AnimatedSprite2D.play("Run")
	
func jump():
	if N_JUMPS > 0:
		velocity.y = JUMP_POWER
		$AnimatedSprite2D.play("Jump")
		

func _physics_process(delta: float) -> void:
	velocity.y = GRAVITY
	if is_on_floor():
		N_JUMPS = 1
		if velocity.x > 0:
			$AnimatedSprite2D.play("Run")
		elif velocity.x == 0:
			$AnimatedSprite2D.play("Idle")
	if see_player():
		move()
	if near_player():
		jump()
	move_and_slide()
