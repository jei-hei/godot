extends KinematicBody2D

export var speed = 200
onready var sprite = $AnimatedSprite
func _ready():
	if Global.char_position != Vector2.ZERO:
		 $".".position = Global.char_position
	OS.center_window()

func _physics_process(delta):
	var way = Vector2.ZERO

	way.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	way.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	way = way.normalized()
	var velocity = way * speed

	if way != Vector2.ZERO:
		if abs(way.x) > abs(way.y):
			sprite.play("walk_right" if way.x > 0 else "walk_left")
		else:
			sprite.play("walk_down" if way.y > 0 else "walk_up")
	else:
		sprite.play("idle")

	move_and_slide(velocity)


func _on_house2_body_entered(body):
	Global.char_position = Vector2(456,733)
	get_tree().change_scene("res://scripts/house2interior.tscn")


func _on_Area2D_body_entered(body):
	Global.char_position = Vector2(408,472)
	get_tree().change_scene("res://scripts/Background.tscn")


func _on_cave_body_entered(body):
	Global.char_position = Vector2(64,256)
	get_tree().change_scene("res://scripts/caveinterior.tscn")


func _on_caveout_body_entered(body):
	Global.char_position = Vector2(1544,688)
	get_tree().change_scene("res://scripts/Background.tscn")
