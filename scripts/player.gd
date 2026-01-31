class_name Player
extends Character

func handle_input():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	if can_attack() && Input.is_action_just_pressed("punch"):
		state = State.PUNCH
