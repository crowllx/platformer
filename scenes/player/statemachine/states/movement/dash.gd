extends GroundState

class_name DashState
var dash := Timer.new()
var dash_cooldown := Timer.new()
@export var dash_duration: float
@export var dash_cd: float
@export var dash_speed: float
var direction = 0

func _ready():
    dash.wait_time = 0.2
    dash.one_shot = true
    dash_cooldown.wait_time = 2.0
    dash_cooldown.one_shot = true
    add_child(dash)
    add_child(dash_cooldown)
    dash.timeout.connect(_on_dash_end)
    dash_cooldown.timeout.connect(get_parent()._on_dash_ready)



func state_process(_delta):
    character.velocity.x = direction * character.dash_speed 
    

func on_enter(_prev_state: State):
    if character.animated_sprite.flip_h == true:
        direction = -1
    else:
        direction = 1
    anim_player.play("dash")
    get_parent().can_dash = false
    dash.start()

func on_exit():
    dash.stop()
    dash_cooldown.start()

func _on_dash_end():
    next_state = "idle"
    dash_cooldown.start()

