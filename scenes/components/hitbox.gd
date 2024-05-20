extends Area2D
class_name HitBox

@export var damage := 10

func _init() -> void:
    collision_layer = 4
    collision_mask = 0

