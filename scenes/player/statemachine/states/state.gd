extends Node
class_name State
signal finished(next_state_name)

@export var can_move: bool = true
var character : CharacterBody2D
var anim_player : AnimationPlayer
var next_state : String = ""



func state_process(_delta):
    pass

func state_input(_event : InputEvent):
    if _event.is_action_pressed("block"):
        next_state = "block"

func on_enter(_prev_state: State):
    pass

func on_exit():
    pass
