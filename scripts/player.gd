class_name Player
extends Character

@onready var enemy_slots : Array = $EnemySlots.get_children()

func handle_input():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	if can_attack() && Input.is_action_just_pressed("punch"):
		state = State.PUNCH
		
func set_heading():
	if velocity.x > 0:
		heading = Vector2.RIGHT
	elif velocity.x < 0:
		heading = Vector2.LEFT

func reserve_slot(enemy: Enemy) -> EnemySlot:
	var available_slots := enemy_slots.filter(
		func(slot): return slot.is_free()
	)
	if available_slots.size() == 0:
		return null
	available_slots.sort_custom(
		func(a: EnemySlot, b: EnemySlot):
			var dist_a := (enemy.global_position - a.global_position).length()
			var dist_b := (enemy.global_position - b.global_position).length()
			return dist_a < dist_b
	)
	available_slots[0].occupy(enemy)
	return available_slots[0]
	
func free_slot(enemy: Enemy) -> void:
	var target_slots := enemy_slots.filter(
			func(slot: EnemySlot): return slot.occupant == enemy
		)
	if target_slots.size() == 1:
		target_slots[0].free_up()
