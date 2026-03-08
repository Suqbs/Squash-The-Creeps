extends Node

@export var mob_scene: PackedScene

var game_score = 0

func _ready() -> void:
	$UserInterface/Retry.hide()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()

	#var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, Vector3.ZERO)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
	# We connect the mob to the score label to update the score upon squashing one.
	mob.squashed.connect(_on_mob_squashed)


func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()
	$UserInterface/Retry/EndScoreLabel.text = "Your Final Score: %s" % game_score
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()

func _on_mob_squashed() -> void:
	game_score += 1
	$UserInterface/ScoreLabel.text = "Score: %s" % game_score
