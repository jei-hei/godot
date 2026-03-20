extends CanvasLayer

onready var life_label = $Control/TextureRect/HBoxContainer/life  # Make sure this path is correct

# Called when the scene is ready
func _ready():
	# Check if the life_label node exists
	if life_label:
		print("Label node found!")
	else:
		print("Label node not found!")

# Function to update the number of lives in the Label
func _update_gui(value):
	# Ensure that the Label node is found before setting the text
	if life_label:
		life_label.text = str(value)  # Display the current lives in the GUI
	else:
		print("Error: life_label node is not found.")
