extends GroundState
class_name Block

func on_enter(_prev_state: State):
    anim_player.play("block_start")
    anim_player.queue("block")

func state_process(_delta):
    if !Input.is_action_pressed("block"):
        next_state = "idle"

    if anim_player["current_animation"] != "block_start":
        anim_player.play("block")
    character.velocity.y = 0
    character.velocity.x = move_toward(character.velocity.x, 0, 50)

func on_exit():
    anim_player.stop()


