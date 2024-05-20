extends State
class_name Attack
var attack_duration := Timer.new()
var basic_attack_chain = Array(["attack1", "attack1", "attack2"])
var chain_count = 0
var chain: bool = false

func _ready():
    attack_duration.one_shot = true
    add_child(attack_duration)
    attack_duration.timeout.connect(_attack_end)

func state_process(_delta):
    character.velocity.y = 0
    character.velocity.x = move_toward(character.velocity.x, 0, 50)
    
func state_input(event):
    var direction = Input.get_axis("move_left","move_right")
    if direction && event.is_action_pressed("dash"):
        attack_duration.stop()
        next_state = "dash"
    elif event.is_action_pressed("block"):
        attack_duration.stop()
        next_state = "block"
    elif event.is_action_pressed("attack") && attack_duration.time_left <= .2:
         chain = true

func on_enter(prev_state: State):
    print(prev_state)
    if prev_state is Block:
        anim_player.play("shield_bash")
    elif prev_state is DashState:
        anim_player.play("attack3")
    else:
        anim_player.play(basic_attack_chain[chain_count])
        chain_count = (chain_count + 1) % basic_attack_chain.size()
    attack_duration.wait_time = anim_player.current_animation_length
    attack_duration.start()
    print(chain_count)

func on_exit():
    chain = false


func _attack_end():
    if chain:
        next_state = "attack"
    else:
        next_state = "idle" 
    anim_player.stop()
    #anim_player.play("RESET")
