extends CanvasLayer

@onready var color_rect := $ColorRect
@onready var setting_option_container := $HBoxContainer
#@onready var resume_home_container := $Panel/HBoxContainer
@onready var resume_home_panel := $Panel
@onready var setting_scene := $SettingScene

func _ready() -> void:
	color_rect.visible = false
	resume_home_panel.visible = false
	setting_scene.visible = false

func _on_setting_pressed() -> void:
	setting_scene.visible = true

func _on_option_pressed() -> void:
	color_rect.visible = true
	resume_home_panel.visible = true
	setting_option_container.visible = false
	var current_scene = get_tree().current_scene
	if current_scene.has_node("TimerNode"):
		var timer_node = current_scene.get_node("TimerNode")
		timer_node.stop_timer()


func _on_resume_pressed() -> void:
	setting_option_container.visible = true
	color_rect.visible = false
	resume_home_panel.visible = false
	var current_scene = get_tree().current_scene
	if current_scene.has_node("TimerNode"):
		var timer_node = current_scene.get_node("TimerNode")
		timer_node.resume_timer()


func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_map.tscn")
