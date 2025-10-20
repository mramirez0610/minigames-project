extends RigidBody2D


# starts animation once a node enters the scene tree for the first time
func _ready() -> void:
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()

# uncheck mask 1 in mask property to ensure mobs dont collide

# process isn't needed, since the animation is taken care of. mobs dont do anything
# except for go forward, which is dealt with in main.gd

# deletes mobs once they leave the screen. why?
# because this is a signal grabbed from "visibleOnScreenNotifier"
# once exited, queue_free() is called which deletes the node at the end of the frame.
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
