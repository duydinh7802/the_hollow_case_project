extends Node2D

@onready var slider := $Board/Label/HSlider
@onready var setting_scene := $"."

func _ready():
	setting_scene.visible = true
	slider.connect("value_changed", Callable(self, "_on_volume_changed"))

func _on_volume_changed(value: float) -> void:
	if value <= 0.01:
		BackgroundMusic.volume_db = -100
	else:
		BackgroundMusic.volume_db = lerp(-80, 0, value)


func _on_back_pressed() -> void:
	setting_scene.visible = false
