extends Node2D

@onready var main_menu := $MainMenu

func _ready():
	main_menu.visible = true

	# Kết nối tín hiệu
	main_menu.start_game.connect(_on_start_game)

func _on_start_game():
	TransitionScreen.transition()
	TransitionScreen.on_animation_finished.connect(_show_level_map)


func _show_level_map():
	get_tree().change_scene_to_file("res://scenes/level_map.tscn")
