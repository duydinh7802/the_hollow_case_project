extends CharacterBody2D

@export var SPEED := 80.0
@onready var player = get_parent().get_node("AllanCharacter")
@onready var anim := $AnimatedSprite2D

enum Direction {
	UP, DOWN, LEFT, RIGHT,
	UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT
}

var last_direction = Direction.DOWN


func _physics_process(delta):
	if not player:
		return

	var dir = player.global_position - global_position

	# Nếu quá gần player → idle
	if dir.length() < 8:
		velocity = Vector2.ZERO
		play_idle()
		return

	# Xác định vector direction
	var ndir = dir.normalized()
	velocity = ndir * SPEED
	play_walk_animation(ndir)

	# Move
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = Vector2.ZERO
		play_idle()


# -----------------------------
# Walk Animation
# -----------------------------
func play_walk_animation(dir: Vector2):

	if abs(dir.x) < 0.3 and dir.y < 0:
		last_direction = Direction.UP
		anim.play("walk_n")

	elif abs(dir.x) < 0.3 and dir.y > 0:
		last_direction = Direction.DOWN
		anim.play("walk_s")

	elif dir.x < 0 and abs(dir.y) < 0.3:
		last_direction = Direction.LEFT
		anim.play("walk_w")
		anim.flip_h = false

	elif dir.x > 0 and abs(dir.y) < 0.3:
		last_direction = Direction.RIGHT
		anim.play("walk_w")
		anim.flip_h = true

	elif dir.x < 0 and dir.y > 0:
		last_direction = Direction.DOWN_LEFT
		anim.play("walk_sw")
		anim.flip_h = false

	elif dir.x > 0 and dir.y > 0:
		last_direction = Direction.DOWN_RIGHT
		anim.play("walk_sw")
		anim.flip_h = true

	elif dir.x < 0 and dir.y < 0:
		last_direction = Direction.UP_LEFT
		anim.play("walk_wn")
		anim.flip_h = false

	elif dir.x > 0 and dir.y < 0:
		last_direction = Direction.UP_RIGHT
		anim.play("walk_wn")
		anim.flip_h = true


# -----------------------------
# Idle dựa trên last_direction
# -----------------------------
func play_idle():
	match last_direction:
		Direction.UP:
			anim.play("idle_n")

		Direction.DOWN:
			anim.play("idle_s")

		Direction.LEFT:
			anim.play("idle_w")
			anim.flip_h = false

		Direction.RIGHT:
			anim.play("idle_w")
			anim.flip_h = true

		Direction.DOWN_RIGHT:
			anim.play("idle_sw")
			anim.flip_h = true

		Direction.DOWN_LEFT:
			anim.play("idle_sw")
			anim.flip_h = false

		Direction.UP_LEFT:
			anim.play("idle_wn")
			anim.flip_h = false

		Direction.UP_RIGHT:
			anim.play("idle_wn")
			anim.flip_h = true
