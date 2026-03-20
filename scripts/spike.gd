extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# Called when the player collides with the spike
func _on_spike_body_entered(body):
	if body.is_in_group("Player"):  # Check if the body is in the Player group
		print("Player hit the spike!")
		Gamestate.hurt_player()  # Call the hurt_player method in GameState to handle losing a life
