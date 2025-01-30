extends Node

@export var mob_scene: PackedScene
var score

func _ready() -> void:
	$Player.hide()

func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	$Player.place()
	
func game_over() -> void:
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over("Game Over", "Dodge the Creeps!")
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Player.hide()
	

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	var rect : Vector2
	var center : Vector2
	
	# FIXME
	# issue: Function "get_viewport_rect()" not found in base self.
	rect = $Player.viewport()
	center = rect / 2

	if 0 == randi() % 2:
		rect.x*= randi() % 2
		rect.y*= randf()
	else:
		rect.y*=randi() % 2
		rect.x*= randf()
	
	# Set the mob's position to a random location.
	mob.position = rect

	# point the mob inside at quarter radians (90 degrees) 
	var direction = roundf((center-rect).angle() * 4.0 / PI ) * PI / 4.0

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
