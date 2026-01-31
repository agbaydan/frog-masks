class_name Enemy
extends Character

@export var player : Player

func handle_input():
	if player != null:
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED
