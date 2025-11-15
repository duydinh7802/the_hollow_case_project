extends Node2D

signal level_2_unlock

@onready var cutscene := $CutScene
@onready var levels := $Levels
@onready var btn_level_1 := $Levels/Level1
@onready var btn_level_2 := $Levels/Level2
@onready var loading := $Loading 

func _ready():
	loading.visible = true
	cutscene.visible = false
	levels.visible = false

	btn_level_2.visible = false

	await get_tree().create_timer(3.5).timeout

	loading.visible = false
	cutscene.visible = true
	levels.visible = false

	# KẾT NỐI ĐÚNG TÊN SIGNAL
	if not GameState.is_connected("level_2_unlock", Callable(self, "_unlock_level_2")):
		GameState.connect("level_2_unlock", Callable(self, "_unlock_level_2"))

	# NẾU GAMESTATE ĐÃ MỞ LEVEL 2 TỪ TRƯỚC → HIỆN NÚT
	if GameState.level_2_unlocked:
		_unlock_level_2()

	# Connect button
	if btn_level_1:
		btn_level_1.pressed.connect(_on_level_1_pressed)

	start_cutscene_transition()


func start_cutscene_transition() -> void:
	await get_tree().create_timer(2.0).timeout
	_start_sweep_transition()

func _start_sweep_transition():
	SweepTransactionScreen.transition()
	SweepTransactionScreen.on_animation_finished.connect(_show_levels)

func _show_levels():
	cutscene.visible = false
	levels.visible = true

func _on_level_1_pressed() -> void:
	TransitionScreen.transition()
	TransitionScreen.on_animation_finished.connect(_show_level_1)

func _show_level_1():
	get_tree().change_scene_to_file("res://scenes/game_play.tscn")

func _unlock_level_2():
	print("UNLOCK LEVEL 2")  # để debug
	btn_level_2.visible = true
	GameState.level_2_unlocked = true    # đảm bảo lưu trạng thái
