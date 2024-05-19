extends GroundState

class_name Moving

func state_process(delta):
    if character.velocity.x == 0:
        next_state = "idle" 

    if !anim_player.is_playing() or anim_player["current_animation"] == "idle":
        anim_player.play("run")

func on_enter(_prev_state: State):
    anim_player.queue("run")


func on_exit():
    if anim_player["current_animation"] == "run":
        anim_player.stop()
