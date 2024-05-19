extends Node

class_name StateMachine

@export var character: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var current_state : State
@onready var state_map: Dictionary = {
    "idle": $Idle,
    "moving": $Moving,
    "block": $Block,
    "attack": $Attack,
    "airbourne": $Airbourne,
    "dash": $Dash
}


var states: Array[State]
var can_dash: bool = true

func _on_dash_ready():
    can_dash = true
    
func _ready():
    for child in get_children():
        if (child is State):
            states.append(child)
            print(child.name)
            print(child)
            child.character = character
            child.anim_player = animation_player
        else:
            push_warning("Child "+child.name+" is not a valid State")

func _physics_process(delta):
    if(current_state.next_state.length() > 0):
        switch_states(state_map[current_state.next_state])
        
    current_state.state_process(delta)

func check_if_can_move():
    return current_state.can_move


func switch_states(new_state : State):
    if(current_state != null):
        current_state.on_exit()
        current_state.next_state = ""
    
    
    new_state.on_enter(current_state)
    current_state = new_state

func _input(event : InputEvent):
    current_state.state_input(event)


