extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_JUMPS = 2          # doble salto
const DASH_SPEED = 600        # velocidad de impulso/dash
const DASH_TIME = 0.2         # duración del dash en segundos
const COYOTE_TIME = 0.15      # tiempo permitido para saltar después de despegar del suelo
const FRICTION = 1000          # para resbalón al detenerse
const MIN_RUN_SPEED = 10      # velocidad mínima para considerar que sigue corriendo

var jumps_done = 0
var is_dashing = false
var dash_timer = 0.0
var coyote_timer = 0.0

var accum = 0
var itera = 0
var conta = 0
var maxim = 160
var steps = 40

var original_offset
var original_position

@onready var anim_sprite: AnimatedSprite2D = $Sprite2D
@onready var cam = $Camera2D
@onready var timer: Timer = $Timer
var jump

func _ready():
	jump = get_node("/root/Ui/Panel/Sprite2D/JumpLabel")

func _physics_process(delta: float) -> void:
	# Recorrido
	if Input.is_action_just_pressed("recorrido"):
		CameraMove()

	# Zoom In con R
	if Input.is_action_just_pressed("zoomIn"):
		smooth_zoom(Vector2(0.5, 0.5))

	# Zoom Out con T
	if Input.is_action_just_pressed("zoomOut"):
		smooth_zoom(Vector2(-0.5, -0.5))

	# ─── Gravedad / caída ───
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer -= delta

	if is_on_floor():
		jumps_done = 0
		coyote_timer = COYOTE_TIME

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# ─── Salto (doble salto + coyote time) ───
	if Input.is_action_just_pressed("ui_accept") and (jumps_done < MAX_JUMPS or coyote_timer > 0):
		velocity.y = JUMP_VELOCITY
		jumps_done += 1
		coyote_timer = 0
		jump.text = str(int(jump.text) - 1)

	# ─── Movimiento horizontal ───
	var direction := Input.get_axis("ui_left", "ui_right")

	if not is_dashing:
		if direction != 0:
			# mover al jugador según input
			velocity.x = direction * SPEED
			anim_sprite.flip_h = direction < 0
		else:
			# ─── Resbalón al detenerse ───
			# Si no hay input, se reduce gradualmente velocity.x usando fricción
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	# ─── Aplicar movimiento ───
	move_and_slide()

	# ─── Animaciones ───
	if is_on_floor():
		jump.text = str(2)
		
	if not is_on_floor():
		anim_sprite.play("jump")
		
	elif abs(velocity.x) > MIN_RUN_SPEED and direction != 0:
		# Solo reproducir run si hay input
		anim_sprite.play("run")
	else:
		# Mientras resbala o está quieto, usar idle
		anim_sprite.play("idle")

func smooth_zoom(step: Vector2):
	# Límite de zoom
	var new_zoom = cam.zoom + step
	if new_zoom.x < 0.5 or new_zoom.y < 0.5: # mínimo
		return
	if new_zoom.x > 2 or new_zoom.y > 2:
		return

	# Animación suave en 5 pasos de 0.1s cada uno
	for i in range(5):
		cam.zoom += step / 5.0
		await get_tree().create_timer(0.1).timeout

func CameraMove():
	original_offset = cam.offset
	original_position = cam.position
	
	cam.drag_horizontal_enabled = false
	cam.drag_vertical_enabled = false
	
	var tween = create_tween()
	
	tween.tween_property(cam, "position", Vector2(2850, 300), 7.0)
	tween.tween_property(cam, "position", Vector2(0, 300), 3.0)
	
	tween.connect("finished", Callable(self, "_on_camera_move_done"))

func _on_camera_move_done():
	cam.drag_horizontal_enabled = true
	cam.drag_vertical_enabled = true
	cam.offset = original_offset
	cam.position = original_position
