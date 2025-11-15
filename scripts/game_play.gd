extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "AllanCharacter":
		call_deferred("_start_transition")

func _start_transition():
	# Bắt đầu hiệu ứng fade
	TransitionScreen.transition()

	# Chờ animation xong rồi đổi scene
	TransitionScreen.on_animation_finished.connect(_go_to_card_scene)

func _go_to_card_scene():
	get_tree().change_scene_to_file("res://scenes/play_card_scene.tscn")
	
