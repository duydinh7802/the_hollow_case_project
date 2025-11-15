extends Node2D

signal timeout_done

@export var total_time_in_secs: int = 90
var remaining_time: int

func _ready():
	remaining_time = total_time_in_secs
	$Timer.wait_time = 1
	$Timer.one_shot = false
	$Timer.start()
	_update_label()
	

func _on_timer_timeout() -> void:
	if remaining_time > 0:
		remaining_time -= 1
		_update_label()
	else:
		$Timer.stop()
		emit_signal("timeout_done")

func _update_label():
	var m = int(remaining_time / 60)
	var s = int(remaining_time % 60)
	$Label.text = "%02d:%02d" % [m, s]
	
func start_countdown(time_in_secs: int):
	total_time_in_secs = time_in_secs
	remaining_time = time_in_secs
	_update_label()
	$Timer.start()	

func stop_timer():
	$Timer.stop()	

func resume_timer():
	if remaining_time > 0 and not $Timer.is_stopped():
		# Timer đang chạy → không cần resume
		return
	
	$Timer.start()
