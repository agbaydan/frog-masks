class_name EnemySlot
extends Node2D

var occupant : Enemy = null

func is_free():
	return occupant == null
	
func free_up():
	occupant = null
		
func occupy(enemy: Enemy):
	occupant = enemy
