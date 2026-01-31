extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $CharSprite

enum State {IDLE, WALK, PUNCH}

var state = State.IDLE

func _physics_process(delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animations()
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
		
func handle_input():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	if can_attack() && Input.is_action_just_pressed("punch"):
		state = State.PUNCH
	
func handle_animations():
	if state == State.IDLE:
		animation_player.play("RESET")
	elif state == State.WALK:
		animation_player.play("walk")
	elif state == State.PUNCH:
		animation_player.play("punch")

func flip_sprites():
	if velocity.x > 0:
		character_sprite.flip_h = false
	elif velocity.x < 0:
		character_sprite.flip_h = true

func can_move():
	return state == State.IDLE || state == State.WALK
		
func can_attack():
	return state == State.IDLE || state == State.WALK
	
func animation_action_complete():
	state = State.IDLE
