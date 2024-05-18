extends Node
class_name Actor

var parent: CharacterBody2D
@onready var statemachine = $StateChart
var action_state: States.Actions = States.Actions.IDLE
var attack_chain: int = 1
func end_attack():
    statemachine.send_event("end_attack")

func _ready():
    action_state = States.Actions.IDLE
    parent = get_parent()

func _physics_process(_delta):
    statemachine.set_expression_property("grounded", parent.is_on_floor()) 
    statemachine.set_expression_property("velocity", parent.velocity)

func _process(delta):
    action_state = parent.get_action_state()
    if Input.is_action_pressed("dash") and Input.get_axis("move_left","move_right") != 0:
        statemachine.send_event("dashing")

    elif Input.is_action_pressed("attack"):
        match action_state:
            States.Actions.BLOCK:
                pass
            States.Actions.ATTACK:
                pass
            _:
                statemachine.send_event("attacking")
    elif Input.is_action_pressed("block",true):
        statemachine.send_event("blocking")
    elif (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and parent.is_on_floor():
        match action_state:
            States.Actions.BLOCK:
                pass
            States.Actions.ATTACK:
                pass
            _:
                statemachine.send_event("moving")

    elif Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
        statemachine.send_event("stop")


func _input(event):
    if event.is_action_pressed("jump") and action_state == States.Actions.AIRBORNE:
        statemachine.send_event("double_jump")
