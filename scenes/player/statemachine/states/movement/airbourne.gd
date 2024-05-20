extends State

class_name AirState

@export var jump_velocity : float = -400

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped = false
var grounded = false

func state_process(_delta):
    var direction = Input.get_axis("move_left","move_right")
    if(character.is_on_floor()): 
        if direction:
            next_state = "moving"
            grounded = true
            return
        else:
            next_state = "idle"
            grounded = true
            return

    if character.is_on_wall():
        anim_player.play("wall_slide")
        anim_player.queue("fall")
        if character.velocity.y >= 0:
            character.velocity.y += (gravity *.4)*_delta
        else:
            character.velocity.y += gravity*_delta
    else:
        # apply gravity
        character.velocity.y += gravity*_delta
        if character.velocity.y >= 0:
            anim_player.play("fall")

    if direction != 0:
        character.velocity.x = move_toward(character.velocity.x, character.speed * direction, 30)
    else:
        character.velocity.x = move_toward(character.velocity.x, 0, character.speed *_delta)




        
func state_input(event : InputEvent):
    if event.is_action_pressed("jump"):
        if character.is_on_wall():
            coyote_jump()
        elif !has_double_jumped:
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
    character.velocity.y = jump_velocity
    anim_player.play("jump")
    has_double_jumped = true

func coyote_jump():
    character.velocity.y = jump_velocity 
    character.velocity.x = 400 * character.get_wall_normal().x
    character.direction = character.get_wall_normal().x
    character.update_flip()
    anim_player.play("jump")
