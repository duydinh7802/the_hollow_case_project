extends CanvasLayer

signal on_animation_finished

@onready var color_react = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	color_react.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_animation_finished.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_react.visible = false		
	
func transition():
	color_react.visible = true
	animation_player.play("fade_to_black")	
