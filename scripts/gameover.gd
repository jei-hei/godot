extends Control

func _ready():

	pass


func _on_TextureButton_pressed():

	Gamestate.live = 3
	Global.global_position = Vector2(1384,568) 
	Global.is_platformer = false  
	get_tree().change_scene("res://scripts/Background.tscn")
