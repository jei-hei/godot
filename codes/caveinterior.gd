extends Node2D

#onready var darkness = $CanvasModulate  # your CanvasModulate node
#
#func _ready():
#	darkness.visible = true  # cave is dark initially
#
## Connect this to the cave entrance Area2D's body_entered signal
#func _on_CaveEntrance_body_entered(body):
#	if body.name == "Player":
#		if Global.has_torch:
#			darkness.visible = false
#			body.light.visible = true   # force torch light on when entering
#		else:
#			darkness.visible = true     # stays dark if no torch
		

onready var canvas_modulate = $CanvasModulate

func _ready():
	if Global.torched_collected:
		canvas_modulate.visible = false
	else:
		# optional: connect if torched node exists
		var torched = get_node_or_null("torched")
		if torched:
			torched.connect("torched_collected", self, "_on_torched_collected")

func _on_torched_collected():
	canvas_modulate.visible = false


