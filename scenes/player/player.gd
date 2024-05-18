extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# child nodes
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D
@onready var statemachine = $Actor

var anim_machine

# character data
const JUMP_VELOCITY = -400
@export var speed = 150
@export var dash_speed = 500
var attack_chain = 1
var can_dash: bool = true
var can_flip: bool = true
var dashing: bool = false
var direction: float = 0
var action_state: States.Actions

func _ready():
    pass
# getters
func get_action_state():
    return action_state

func update_flip(dir):
    if dir == 1:
        animated_sprite.flip_h = false
    elif dir == -1:
        animated_sprite.flip_h = true

func readjust_horizontal():
    var pos: int
    if animated_sprite.flip_h == true:
        pos = -30
    else:
        pos = 30
    animated_sprite.position = Vector2(pos, -32)

func _process(delta):
    print(action_state)
    match action_state:
        States.Actions.RUN:
            pass
        States.Actions.ATTACK:
            direction = 0
        States.Actions.BLOCK:
            direction = 0
        States.Actions.RUN:
            if animation_player.current_animation != "run":
                animation_player.queue("run")
        States.Actions.IDLE:
            direction = 0
            animation_player.queue("idle")
        States.Actions.AIRBORNE:
            if velocity.y > 0:
                animation_player.queue("fall")
            elif velocity.y > -100:
                animation_player.queue("airborne")
        _:
            pass

func _physics_process(delta): 
    # update state machine expression variables
    # Add the gravity.
    if not is_on_floor():
        velocity.y += gravity*delta
    match action_state:
        States.Actions.BLOCK:
            pass
        States.Actions.ATTACK:
            pass
        States.Actions.DASH:
            pass
        States.Actions.AIRBORNE:
            direction = Input.get_axis("move_left","move_right")
        _:
            direction = Input.get_axis("move_left","move_right")

    if Input.is_action_pressed("jump"):
        if is_on_floor():
            animation_player.play("jump")
            velocity.y = JUMP_VELOCITY

    var spd = dash_speed if dashing else speed
    if direction:
        velocity.x = direction * spd
    else:
        velocity.x = move_toward(velocity.x, 0, 20)

    update_flip(direction)
    move_and_slide()

### SIGNALS

#### State management
func _on_run_state_entered():
    action_state = States.Actions.RUN
    match animation_player["current_animation"]:
        "idle":
            animation_player.stop()
        "run_end":
            animation_player.stop()
        _:
            pass
    animation_player.play("run")

func _on_stop_taken():
    action_state = States.Actions.IDLE
    animation_player.play("run_end")
    direction = 0

func _on_dash_state_entered():
    action_state = States.Actions.DASH
    direction = Input.get_axis("move_left","move_right")
    animation_player.play("dash")
    dashing = true
    can_dash = false

func _on_dash_state_exited():
    dashing = false
    can_dash = true

func _on_idle_state_entered():
    action_state = States.Actions.IDLE


func _on_block_state_entered():
    action_state = States.Actions.BLOCK
    animation_player.play("block")

func _on_attack_state_entered():
    action_state = States.Actions.ATTACK
    animation_player.play("attack"+str(attack_chain))
    print(attack_chain)
    if attack_chain > 2:
        attack_chain = 1
    else:
        attack_chain += 1



func _on_block_state_exited():
    if not Input.is_action_pressed("block"):
        action_state = States.Actions.IDLE
        animation_player.stop()
        animation_player.play("idle")
    
func _on_attack_state_exited():
    action_state = States.Actions.IDLE


func _on_airbourne_child_state_entered():
    action_state = States.Actions.AIRBORNE


func _on_grounded_taken():
    action_state = States.Actions.IDLE
    animation_player.play("landing")
    can_flip = true


func _on_jump_state_entered():
    can_flip = true


func _on_fall_state_entered():
    velocity.y = JUMP_VELOCITY
    animation_player.play("flip")
    can_flip = false
