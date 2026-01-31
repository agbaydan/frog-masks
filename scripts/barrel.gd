extends StaticBody2D

@export var knockback_intensity : float

@onready var hit_detector := $HitDetector

var velocity := Vector2.ZERO

func _ready() -> void:
	hit_detector.hit.connect(on_hit.bind())
	
func _process(delta: float) -> void:
	position += velocity * delta
	
func on_hit(direction: Vector2):
	velocity = direction * knockback_intensity
