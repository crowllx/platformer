extends Area2D
class_name KillZone

@onready var timer = $Timer
@export var duration: float = 3
func _on_body_entered(_body):
    timer.start()

func _on_timer_timeout():
    get_tree().reload_current_scene()
