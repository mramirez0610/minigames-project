extends Node
@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()   
	$HUD.show_game_over()

func new_game(): 
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	get_tree().call_group("mobs", "queue_free")
	$HUD.show_message("get ready!")
	$Music.play

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
	
	#add mob to the scene (spawn)
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
