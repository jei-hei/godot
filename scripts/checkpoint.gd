extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("checkpoint")

# When the player enters the checkpoint area
func _on_checkpoint_body_entered(body):
	if body.is_in_group("Player"): 
		
		get_tree().call_group("GameState", "set_checkpoint", body.global_position)
		print("Checkpoint reached! Position saved: ", body.global_position)  # Debug print
		
		set_deferred("monitoring",false)
