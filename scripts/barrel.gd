extends StaticBody2D

@export var knockback_intensity : float

@onready var sprite := $Sprite2D
@onready var hit_detector := $HitDetector

enum State {IDLE, DEFEATED}

var state := State.IDLE
var velocity := Vector2.ZERO

func _ready() -> void:
	hit_detector.hit.connect(on_hit.bind())
	
func _process(delta: float) -> void:
	position += velocity * delta
	
func on_hit(direction: Vector2):
	if state == State.IDLE:
		sprite.frame = 1
		state = State.DEFEATED
		modulate.a = 0.5
		$DestroyTimer.start()
	velocity = direction * knockback_intensity

func _on_destroy_timer_timeout() -> void:
	print("DESTROY")
	queue_free()
