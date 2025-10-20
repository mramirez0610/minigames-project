extends Node
# first, we instance the Player scene in the scene explorer.

# then, we create our timers, and start position (which we set to the middle of the screen).

# we then create our mobPath, and set our corners and "curve"
# we create a mobSpawnLocation child, which we will randomly access.

# we export the mob scene that we want to instance
# select file in the inspector, our PackedScene
# whatever we name this & our instantiate, will change our name in our inspector
@export var mob_scene: PackedScene
var score

# _ready and _process aren't needed, since timers are handling logic
# it seems that anything that isn't being controlled doesn't explicitly need them? as long
# as logic is being handled elsewhere, it seems okay?

# ends game, ends timers, game over.
# connected to our HIT signal, in our Player
# depends on if _body is entered by rigidBody2D.
# stops timers, music, and shows Game_Over from HUD
# Game_Over shows Start_Button, which is connected to new game
# once pressed, start_button is hidden, and start_game is emitted,
# which calls our new_game! which is right below.
func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()   
	$HUD.show_game_over()

# self explanatory
# connected to our start_game signal in HUD, which is connected to our button signal
func new_game(): 
	score = 0
	# starts at our assigned position in StartPosition node
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	# clears mobs!
	get_tree().call_group("mobs", "queue_free")
	$HUD.show_message("get ready!")
	$Music.play()

# spawns a mob every time MobTimer runs out, every 0.5 seconds.
# this is a signal grabbed from MobTimer itself
func _on_mob_timer_timeout() -> void:
	#new instance of mob scene
	var mob = mob_scene.instantiate()
	
	#random pos through 2d path
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	#set mob position to rand pos created
	mob.position = mob_spawn_location.position
	
	#set mob direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	#randomness to direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#choosing velocity
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#add mob to the scene (spawn), every 0.5 seconds.
	add_child(mob)

# every time the score timer runs out, you gain a point (every second)
# signal from ScoreTimer
func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

# after our two second delay, our main score timers start
# signal from StartTimer
func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
