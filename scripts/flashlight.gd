extends Node2D

signal flashlight_collected

func _ready():
	if Global.flashlight_collected == true:
		queue_free()



# Called when the flashlight is collected
func _on_Area2D_body_entered(body):
	if body.name == "KinematicBody2D":  # Assuming the player is KinematicBody2D
		print("Flashlight collected")
		Global.flashlight_collected = true  # Update global flag for flashlight
		emit_signal("flashlight_collected")  # Emit signal to notify other nodes
	if $AnimationPlayer.has_animation("flashlight_animation"):
		$AnimationPlayer.play("flashlight_animation")  # Play collection animation
	queue_free()  # Completely remove flashlight from the scene after collection
