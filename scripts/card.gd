extends Node2D


signal card_flipped(card: Node)   
signal card_clicked(card: Node)   

var is_toggle: bool = false
var allow_flip: bool = true

@export var card_frame: int

func _ready():
	is_toggle = false
	$Back/Cards.animation = "turn"
	$Back/Cards.frame = card_frame

func flip_back():
	$AnimationPlayer.play("turn_back")
	is_toggle = false	

func set_allow_flip(value: bool):
	allow_flip = value

func flip_up():
	if not is_toggle:
		$AnimationPlayer.play("turn_over")
		is_toggle = true


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		if not is_toggle and allow_flip:
			$AnimationPlayer.play("turn_over")
			is_toggle = true
			emit_signal("card_flipped", self)
