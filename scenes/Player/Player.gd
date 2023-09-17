extends CharacterBody2D


@export var speed = 20


func _process(delta):
	var velocity: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		velocity.y -= speed
	
	if Input.is_action_pressed("move_down"):
		velocity.y += speed
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
	
	move_and_collide(velocity * delta)
