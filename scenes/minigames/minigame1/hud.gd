extends CanvasLayer
# custom signal that notifies Main that our button is pressed
signal start_game

# _ready and _process not needed, since this isnt being updated every frame, unlike our entities

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("game over!")
	#wait until message timer shows
	await $MessageTimer.timeout
	
	$Message.text = "dodge the creeps!"
	$Message.show()
	
	#make a new one-shot timer and wait for it to finish
	#according to docs, this is the best way to quickly create a timer
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

# signal from StarButton in HUD
# our pressed signal emits our start_game signal
func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

# signal from MessageTimer in HUD
# once 2 seconds is up
func _on_message_timer_timeout() -> void:
	$Message.hide()
