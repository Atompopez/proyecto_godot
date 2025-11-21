extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980

func _ready():
	velocity.x = SPEED
	$AnimatedSprite2D.play("default")
	
func _next_to_left_wall():
	return $Left.is_colliding()
	
func _next_to_rigth_wall():
	return $Right.is_colliding()
	
func flip():
	if _next_to_left_wall() or _next_to_rigth_wall():
		velocity.x *= -1
		$AnimatedSprite2D.scale.x *= -1

func _physics_process(delta: float) -> void:
	velocity.y = GRAVITY
	flip()
	move_and_slide()
