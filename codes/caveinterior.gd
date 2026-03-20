extends Node2D

onready var canvas_modulate = $CanvasModulate

# =====================================
# READY
# =====================================
func _ready():
	# If the torch is collected, disable the canvas modulate (darkness)
	if Global.torched_collected:
		canvas_modulate.visible = false
	else:
		# Optionally, connect the signal if the torch node exists
		var torched = get_node_or_null("torched")
		if torched:
			torched.connect("torched_collected", self, "_on_torched_collected")

# =====================================
# SIGNAL HANDLER (When torch is collected)
# =====================================
func _on_torched_collected():
	canvas_modulate.visible = false  # Disable darkness when the torch is collected
