extends Node2D



#func _ready():
#	if Global.torched_collected == true:
#		_die()
#
#
#
#
#func _on_Area2D_body_entered(body):
#	Global.torched_collected = true
#	$AnimationPlayer.play("key_animation")
#
#
#func _die():
#		queue_free()



signal torched_collected

func _ready():
	if Global.torched_collected == true:
		queue_free()


#
#func _on_Area2D_body_entered(body):



func _on_Area2D_body_entered(body):
	if body.name == "KinematicBody2D":
		print("collected") 
		Global.torched_collected = true   # set global flag
		emit_signal("torched_collected")
		if $AnimationPlayer.has_animation("torched_animation"):
			$AnimationPlayer.play("torched_animation")
		queue_free()
