extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# child nodes
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D
@onready var statemachine = $StateMachine

# character data
const JUMP_VELOCITY = -500
@export var speed = 300
@export var dash_speed = 1100
var direction: float

func _ready():
    for anim in animation_player.get_animation_list():
        animation_player.get_animation(anim).loop_mode = 0

func update_flip():
    if direction == 1:
        animated_sprite.flip_h = false
    elif direction == -1:
        animated_sprite.flip_h = true
func _physics_process(delta): 
    # apply gravity
    if not is_on_floor():
        velocity.y += gravity*delta

    if Input.is_action_pressed("jump"):
        if is_on_floor():
            velocity.y = JUMP_VELOCITY
    if statemachine.current_state is DashState:
        velocity.x = direction * dash_speed
    else:
        direction = Input.get_axis("move_left","move_right")
    if direction != 0 && statemachine.check_if_can_move():
        if statemachine.current_state is DashState:
            velocity.x = direction * dash_speed
        else:
            velocity.x = direction * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)

    move_and_slide()
    update_flip()
    update_animation()


func update_animation():
    #if !animation_player.is_playing() && is_on_floor():
    #    if direction:
    #        animation_player.play("run")
    #    else:
    #        animation_player.play("idle")
    pass
