extends State

class_name GroundState

@export var jump_velocity : float = -400
@export var jump_animation : String = "jump"

func state_process(_delta):
    if(!character.is_on_floor()):
        next_state = "airbourne"
        return
    var direction = Input.get_axis("move_left","move_right")
    if self is Idle && direction != 0:
        next_state = "moving"
    elif self is Moving && direction == 0:
        next_state = "idle"
    
    if direction != 0:
        character.velocity.x = direction * character.speed
    else:
        character.velocity.x = move_toward(character.velocity.x, 0, character.speed)

func state_input(event : InputEvent):
    if(event.is_action_pressed("jump")):
        jump()

    elif event.is_action_pressed("dash") && get_parent().can_dash:
        next_state = "dash"
    elif event.is_action_pressed("attack"):
        next_state = "attack"
    elif event.is_action_pressed("block"):
        next_state = "block"
        
func jump():
    character.velocity.y = jump_velocity
    next_state = "airbourne"
    anim_player.play("jump")
