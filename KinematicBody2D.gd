extends KinematicBody2D

export var speed = 200
onready var sprite = $AnimatedSprite

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
