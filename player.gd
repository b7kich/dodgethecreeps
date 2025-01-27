extends CharacterBody2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).

var margins : Vector4

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	if dir:
		velocity = dir * speed
		$AnimatedSprite2D.play()
	else:
		velocity.x = move_toward(velocity.x, 0,speed)
		velocity.y = move_toward(velocity.y, 0,speed)
		$AnimatedSprite2D.stop()
	
	move_and_slide()
	checkHit()
		
	position.x = clamp(position.x, margins.x, margins.w)
	position.y = clamp(position.y, margins.y, margins.z)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "right"
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.flip_v = false
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func checkHit() -> void:
	if get_slide_collision_count()>0: 
		hit.emit()	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	place();

func place() -> void:
	var viewport_size = viewport()
	var half_char_size = get_node("CollisionShape2D").shape.get_rect().size / 2
	margins = Vector4(half_char_size.x,half_char_size.y,viewport_size.y-half_char_size.y,viewport_size.x-half_char_size.x)
	position = viewport_size /2
	position.y += 200
	show()
	
func viewport() -> Vector2:
	return get_viewport_rect().size
