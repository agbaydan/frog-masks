class_name Character
extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var knockback_intensity : float
@export var attack_length: float

@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $CharSprite
@onready var hit_emitter := $HitEmitter
@onready var hit_detector := $HitDetector

enum State {IDLE, WALK, PUNCH, HURT}

var state = State.IDLE
var heading = Vector2.RIGHT

func _ready() -> void:
	hit_emitter.area_entered.connect(on_hit.bind())
	hit_detector.hit.connect(on_get_hit.bind())

func _physics_process(delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animations()
	set_heading()
	flip_sprites()
	move_and_slide()

func handle_movement():
	if can_move():
		if velocity.length() == 0:
			state = State.IDLE
		else: 
			state = State.WALK
	else:
		velocity = Vector2.ZERO
		
# Handled in Player class
func handle_input():
	pass
	
func handle_animations():
	if state == State.IDLE:
		animation_player.play("RESET")
	elif state == State.WALK:
		animation_player.play("walk")
	elif state == State.PUNCH:
		animation_player.play("punch")
	elif state == State.HURT:
		animation_player.play("hurt")
		
func set_heading():
	pass

func flip_sprites():
	if heading == Vector2.RIGHT:
		character_sprite.flip_h = false
		hit_emitter.position.x = 10
	elif velocity.x < 0:
		character_sprite.flip_h = true
		hit_emitter.position.x = -10

func can_move():
	return state == State.IDLE || state == State.WALK
		
func can_attack():
	return state == State.IDLE || state == State.WALK
	
func animation_action_complete():
	state = State.IDLE

func on_hit(hit_box: HitDetector):
	var direction = Vector2.LEFT if hit_box.global_position.x < global_position.x else Vector2.RIGHT
	hit_box.hit.emit(direction)
	
func on_get_hit(direction: Vector2):
	velocity = direction * knockback_intensity
	state = State.HURT
	
func on_destroy():
	queue_free()
