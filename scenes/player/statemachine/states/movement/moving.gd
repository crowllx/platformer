extends GroundState

class_name Moving
func on_enter(_prev_state: State):
    anim_player.queue("run")

func on_exit():
    if anim_player["current_animation"] == "run":
        anim_player.stop()
