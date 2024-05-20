extends Area2D
class_name HurtBox

signal damage_taken

func _init() -> void:
    collision_layer = 0
    collision_mask = 4


func _ready() -> void:
    self.connect("area_entered", _on_area_entered)



func _on_area_entered(hitbox: HitBox) -> void:
    if hitbox == null:
        return
    emit_signal("damage_taken")
    
