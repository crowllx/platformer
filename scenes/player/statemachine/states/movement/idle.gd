extends GroundState

class_name Idle

func on_enter(_prev_state: State):
    if anim_player["current_animation"] == "run":
        anim_player.stop()

    anim_player.queue("idle")

func on_exit():
    anim_player.stop()


