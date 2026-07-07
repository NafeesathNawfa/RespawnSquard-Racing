extends CharacterBody2D

@export var max_speed: float = 700.0
@export var acceleration: float = 300.0
@export var friction: float = 180.0
@export var grip: float = 10.0
@export var drag: float = 0.2
var speed := 0.0
var move_dir :=Vector2.ZERO


@onready var spriteTop: Sprite2D = %SpriteTop
@onready var spriteSide: Sprite2D = %SpriteSide
@onready var bike_collision_shape: CollisionShape2D = $BikeCollisionShape

func _ready() -> void:
	spriteTop.visible = true
	spriteSide.visible = false

func _physics_process(delta: float) -> void:
	var input_direction = Vector2(
		Input.get_axis("move_left","move_right"),
		Input.get_axis("move_up","move_down")
		).normalized()
		
	input_direction = snap_to_axis(input_direction)
	
	if input_direction != Vector2.ZERO:
		move_dir = move_dir.lerp(input_direction, grip * delta)
		velocity += input_direction * acceleration * delta
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	velocity = velocity * (1 - drag * delta) 
	
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	move_and_slide()
	
	if velocity.x > 0.0:
		spriteSide.visible = true
		spriteTop.visible = false
		bike_collision_shape.rotation_degrees = 90
		spriteSide.flip_v = false
	elif velocity.x < 0.0:
		spriteSide.visible = true
		spriteTop.visible = false
		bike_collision_shape.rotation_degrees = 90
		spriteSide.flip_v = true
	elif velocity.y != 0.0:
		spriteSide.visible = false
		bike_collision_shape.rotation_degrees = 0
		spriteTop.visible = true

func snap_to_axis(dir: Vector2) -> Vector2:
	if abs(dir.x) > abs(dir.y):
		return Vector2(sign(dir.x),0)
	elif abs(dir.y) > abs(dir.x):
		return Vector2(0,sign(dir.y))
	return Vector2.ZERO
