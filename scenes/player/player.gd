extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# child nodes
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D
@onready var statemachine = $StateMachine
@onready var hitbox_pivot = %HitBoxPivot
# character data
const JUMP_VELOCITY = -400
@export var speed = 300
@export var dash_speed = 1100
@export var direction: float

func _ready():
    for anim in animation_player.get_animation_list():
        animation_player.get_animation(anim).loop_mode = 0

func update_flip():
    if direction == 1:
        animated_sprite.flip_h = false
        hitbox_pivot.rotation = 0
    elif direction == -1:
        animated_sprite.flip_h = true
        hitbox_pivot.rotation_degrees = -180
func _physics_process(delta): 

    #if statemachine.current_state is DashState:
    #    velocity.x = direction * dash_speed
    #else:
    direction = Input.get_axis("move_left","move_right")
    # default gravity
    if !statemachine.current_state is AirState && !statemachine.current_state is Attack:
        velocity.y += gravity * delta

    move_and_slide()
    update_flip()
    update_animation()


func update_animation():
    if is_on_floor():
        if statemachine.current_state is Moving:
            animation_player.play("run")
        elif statemachine.current_state is Idle:
            animation_player.play("idle")
    pass
