class_name Enemy
extends Character

@export var attack_cooldown : int
@export var player : Player

var player_slot : EnemySlot = null
var time_since_attack = Time.get_ticks_msec()

func handle_input():
	if player != null && can_move():
		
		if player_slot == null:
			player_slot = player.reserve_slot(self)
			
		if player_slot != null:
			var direction = (player_slot.global_position - global_position).normalized()
			if is_player_within_range():
				velocity = Vector2.ZERO
				if can_attack():
					time_since_attack = Time.get_ticks_msec()
					state = State.PUNCH
			else:
				velocity = direction * SPEED

func is_player_within_range() -> bool:
	return (player_slot.global_position - global_position).length() < 1
	
func can_attack() -> bool:
	if Time.get_ticks_msec() - time_since_attack < attack_cooldown:
		return false
	return super.can_attack()
		

func set_heading():
	if player == null:
		return
	if position.x > player.position.x:
		heading = Vector2.LEFT
	else:
		heading = Vector2.RIGHT
