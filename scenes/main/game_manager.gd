extends Node
# string set from RN. soooo cool
var game_to_load: String = "Minigame1"  

func _ready():
	if game_to_load == "":
		push_error("no game selected!")
		return
	
	var path = "res://scenes/minigames/%s/Minigame1.tscn" % game_to_load
	var scene = load(path)
	if scene:
		var instance = scene.instantiate()
		add_child(instance)
	else:
		push_error("Game not found: " + path)
