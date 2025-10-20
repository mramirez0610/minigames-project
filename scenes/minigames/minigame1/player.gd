extends Area2D

#creating our custom hit signal
#emits when colliding with enemy
signal hit

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#grabs screen size
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# animation, mostly.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	#prevents player from leaving screen
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

# our signal that we grabbed from Area2D, our initial node that we created (our Player scene)
# not from the animated sprite or collision shape, but from area2d
# this works because of the Node2D in our body parameter. our enemies are RigidBody2D nodes,
# which is why this is working correctly.
# when would i use area_entered?
func _on_body_entered(_body: Node2D) -> void:
	#player scene disappears
	hide()
	#our custom hit signal is emitted
	hit.emit()
	#disable our areas collision shape
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	#sets new starting position, which is (?)
	position = pos
	#re-enables player scene
	show()
	#re-enables collision
	$CollisionShape2D.disabled = false
