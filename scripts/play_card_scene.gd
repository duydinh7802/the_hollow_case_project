extends Node2D

const CARD_SCENE = preload("res://scenes/card.tscn")

@export var pairs_count: int = 5
@export var cards_per_row: int = 5
@export var spacing_x: float = 120.0
@export var spacing_y: float = 180.0
@export var total_cards: int = 10
@export var game_time: int = 180
@onready var game_noti = $GameNoti 

var flipped_cards: Array = []
var can_flip: bool = true
var matched_pairs: int = 0
var total_pairs: int

func _ready():
	randomize()
	total_pairs = pairs_count

	# 🕒 Bắt đầu đếm ngược
	$TimerNode.start_countdown(game_time)
	$TimerNode.connect("timeout_done", Callable(self, "_on_game_timeout"))

	_spawn_cards()


func _spawn_cards():
	var selected_cards: Array = []
	while selected_cards.size() < pairs_count:
		var r = randi_range(0, total_cards - 1)
		if r not in selected_cards:
			selected_cards.append(r)

	var all_cards = selected_cards + selected_cards.duplicate()
	all_cards.shuffle()

	var screen_size = get_viewport_rect().size
	var num_rows = ceil(float(all_cards.size()) / float(cards_per_row))
	var total_height = (num_rows - 1) * spacing_y
	var start_y = (screen_size.y - total_height) / 2

	for i in range(all_cards.size()):
		var card = CARD_SCENE.instantiate()
		card.card_frame = all_cards[i]
		add_child(card)

		var row = i / cards_per_row
		var col = i % cards_per_row

		var total_width = (cards_per_row - 1) * spacing_x
		var start_x = (screen_size.x - total_width) / 2

		card.position = Vector2(start_x + col * spacing_x, start_y + row * spacing_y)
		card.connect("card_flipped", Callable(self, "_on_card_flipped"))


func _on_card_flipped(card: Node):
	if not can_flip or card in flipped_cards:
		return

	flipped_cards.append(card)

	if flipped_cards.size() == 2:
		_set_allow_flip(false)
		can_flip = false

		var first = flipped_cards[0]
		var second = flipped_cards[1]

		await get_tree().create_timer(0.6).timeout

		if first.card_frame == second.card_frame:
			await get_tree().create_timer(0.5).timeout
			first.queue_free()
			second.queue_free()
			matched_pairs += 1

			if matched_pairs == total_pairs:
				_on_game_win()
		else:
			$Camera2D.screen_shake(8, 0.5)
			await get_tree().create_timer(0.5).timeout
			first.flip_back()
			second.flip_back()

		flipped_cards.clear()
		can_flip = true
		_set_allow_flip(true)


func _set_allow_flip(value: bool):
	for c in get_children():
		if c.has_method("set_allow_flip"):
			c.set_allow_flip(value)


# 🕒 Khi hết giờ
func _on_game_timeout():
	if matched_pairs < total_pairs:
		print("⏰ Hết giờ! Bạn thua 😢")
		can_flip = false
		_set_allow_flip(false)
		_reveal_all_cards()
		game_noti.show_message("LOSE")
	else:
		_on_game_win()


# 🏆 Khi thắng
func _on_game_win():
	print("🎉 Bạn đã thắng!")
	$TimerNode.stop_timer()
	game_noti.show_message("WIN")  


# 👁️‍🗨️ Lật ngửa toàn bộ bài còn lại khi thua
func _reveal_all_cards():
	for c in get_children():
		if c.has_method("flip_up"):
			c.flip_up()
