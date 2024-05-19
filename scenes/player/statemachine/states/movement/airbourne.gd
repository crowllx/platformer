extends State

class_name AirState

@export var double_jump_velocity : float = -400

var has_double_jumped = false
var grounded = false

func state_process(_delta):
    if(character.is_on_floor()):
        var direction = Input.get_axis("move_left","move_right")
        if direction:
            next_state = "moving"
            grounded = true
        else:
            next_state = "idle"
            grounded = true
        
func state_input(event : InputEvent):
    if(event.is_action_pressed("jump") && !has_double_jumped):
        double_jump()
    elif event.is_action_pressed("attack"):
        next_state = "attack"

func on_enter(_prev_state: State):
    grounded = false

func on_exit():
    if(grounded):
        anim_player.play("landing")
        has_double_jumped = false
        grounded = false

func double_jump():
    character.velocity.y = double_jump_velocity
    anim_player.play("jump")
    has_double_jumped = true
