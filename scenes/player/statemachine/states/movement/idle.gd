extends GroundState

class_name Idle


func state_process(_delta):
    if character.velocity.x != 0:
        next_state = "moving"

    if !anim_player.is_playing():
        anim_player.play("idle")

func on_enter(_prev_state: State):
    if anim_player["current_animation"] == "run":
        anim_player.stop()

    anim_player.queue("idle")

func on_exit():
    anim_player.stop()


