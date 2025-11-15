extends Node2D

signal start_game

@onready var setting_scene := $SettingScene

func _ready() -> void:
	setting_scene.visible = false

func _on_startgame_pressed() -> void:
	emit_signal("start_game")

func _on_setting_pressed() -> void:
	setting_scene.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()
