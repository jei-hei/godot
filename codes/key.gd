extends Node2D

func _ready():
	if Global.key_taken == true:
		_die()

func _on_Area2D_body_entered(body):
	print("collected") 
	Global.key_taken = true
	$AnimationPlayer.play("key_animation")

func _die():
	queue_free()
