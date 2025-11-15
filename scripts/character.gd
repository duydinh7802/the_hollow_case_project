extends CharacterBody2D

const SPEED = 100.0
var target_position: Vector2
var is_moving: bool = false
var last_direction

enum direction {
	UP, UP_RIGHT, UP_LEFT,
	DOWN, DOWN_RIGHT, DOWN_LEFT,
	LEFT, RIGHT, IDLE
}

func _ready():
	target_position = global_position

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		target_position = event.position
		is_moving = true

func _process(delta):
	if is_moving:
		move_to_target()
	else:
		idle()

func move_to_target():
	var dir = target_position - global_position

	# Khi tới nơi (độ lệch nhỏ)
	if dir.length() < 4:
		velocity = Vector2.ZERO
		is_moving = false
		return
	
	# Hướng di chuyển
	velocity = dir.normalized() * SPEED
	set_animation_from_direction(dir.normalized())

	move_and_slide()

func set_animation_from_direction(dir: Vector2):
	# Xác định hướng theo vector
	if abs(dir.x) < 0.3 and dir.y < 0:
		last_direction = direction.UP
		$AnimatedSprite2D.play("walk_n")

	elif abs(dir.x) < 0.3 and dir.y > 0:
		last_direction = direction.DOWN
		$AnimatedSprite2D.play("walk_s")

	elif dir.x < 0 and abs(dir.y) < 0.3:
		last_direction = direction.LEFT
		$AnimatedSprite2D.play("walk_w")
		$AnimatedSprite2D.flip_h = false

	elif dir.x > 0 and abs(dir.y) < 0.3:
		last_direction = direction.RIGHT
		$AnimatedSprite2D.play("walk_w")
		# Flip hướng phải
		$AnimatedSprite2D.flip_h = true

	elif dir.x < 0 and dir.y > 0:
		last_direction = direction.DOWN_LEFT
		$AnimatedSprite2D.play("walk_sw")
		$AnimatedSprite2D.flip_h = false

	elif dir.x > 0 and dir.y > 0:
		last_direction = direction.DOWN_RIGHT
		$AnimatedSprite2D.play("walk_sw")
		$AnimatedSprite2D.flip_h = true

	elif dir.x < 0 and dir.y < 0:
		last_direction = direction.UP_LEFT
		$AnimatedSprite2D.play("walk_wn")
		$AnimatedSprite2D.flip_h = false

	elif dir.x > 0 and dir.y < 0:
		last_direction = direction.UP_RIGHT
		$AnimatedSprite2D.play("walk_wn")
		$AnimatedSprite2D.flip_h = true

func idle():
	match last_direction:
		direction.UP:
			$AnimatedSprite2D.play("idle_w")
		direction.DOWN:
			$AnimatedSprite2D.play("idle_s")
		direction.LEFT:
			$AnimatedSprite2D.play("idle_w"); $AnimatedSprite2D.flip_h = false
		direction.RIGHT:
			$AnimatedSprite2D.play("idle_w"); $AnimatedSprite2D.flip_h = true
		direction.DOWN_RIGHT:
			$AnimatedSprite2D.play("idle_sw"); $AnimatedSprite2D.flip_h = true
		direction.DOWN_LEFT:
			$AnimatedSprite2D.play("idle_sw"); $AnimatedSprite2D.flip_h = false
		direction.UP_LEFT:
			$AnimatedSprite2D.play("idle_wn"); $AnimatedSprite2D.flip_h = false
		direction.UP_RIGHT:
			$AnimatedSprite2D.play("idle_wn"); $AnimatedSprite2D.flip_h = true
