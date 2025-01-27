extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

@export var speed = 400 # How fast the player will move (pixels/sec).

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over(game_over, title):
	show_message(game_over)
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = title
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$TouchButton.show()
	

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$TouchButton.hide()
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()
