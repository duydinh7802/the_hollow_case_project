extends CanvasLayer

@onready var label = $ColorRect/Panel/Label
@onready var next = $ColorRect/Panel/Next
@onready var replay = $ColorRect/Panel/Replay

func _ready() -> void:
	self.visible = false

func show_message(text: String) -> void:
	if text == "WIN":
		next.visible = true
		replay.visible = false
	elif text == "LOSE":
		next.visible = false
		replay.visible = true
	label.text = text
	self.visible = true
	$AnimationPlayer.play("display")

func hide_message() -> void:
	self.visible = false

func _on_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/play_card_scene.tscn")

func _on_next_pressed() -> void:
	GameState.level_2_unlocked = true
	GameState.emit_signal("level_2_unlock")
	get_tree().change_scene_to_file("res://scenes/level_map.tscn")
	
