extends Node

signal level_2_unlock

var level_2_unlocked: bool = false


func unlock_level_2():
	if not level_2_unlocked:
		level_2_unlocked = true
		level_2_unlock.emit()
