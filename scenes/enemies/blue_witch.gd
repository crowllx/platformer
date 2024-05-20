extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite = $AnimatedSprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func death():
    queue_free()
    
func _on_hurt_box_damage_taken():
    sprite.play("death")
    sprite.connect("animation_finished", death)
