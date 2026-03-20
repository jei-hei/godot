extends KinematicBody2D

# =====================================
# SETTINGS
# =====================================
export var speed : float = 200
export var gravity : float = 2000
export var jump_speed : float = 800
var motion = Vector2()
const UP = Vector2(0, -1)
const world_limit = 2000
var velocity = Vector2.ZERO
var is_platformer = false
var start_position = Vector2()

onready var light = $Light2D
onready var sprite = $AnimatedSprite

# =====================================
# READY
# =====================================
func _ready():
	light.visible = false
	add_to_group("Player")
	if Global.flashlight_collected:
		light.visible = true
	
	# Set initial position based on saved character position
	if Gamestate.current_checkpoint != Vector2():
		position = Gamestate.current_checkpoint
	
	is_platformer = Global.is_platformer
	
	OS.center_window()
	add_to_group("Player")
	start_position = global_position

# =====================================
# INPUT (LIGHT TOGGLE)
# =====================================
func _input(event):
	# Only toggle flashlight if it has been collected
	if event.is_action_pressed("toggle_light") and Global.flashlight_collected:
		light.visible = !light.visible  # Toggle flashlight visibility

# =====================================
# MAIN PHYSICS
# =====================================
func _physics_process(delta):
	if is_platformer:
		platformer_mode(delta)
	else:
		topdown_mode()

# =====================================
# WORLD 1 – TOP DOWN (NO GRAVITY)
# =====================================
func topdown_mode():
	var way = Vector2.ZERO
	
	way.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	way.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	way = way.normalized()
	velocity = way * speed

	if way != Vector2.ZERO:
		if abs(way.x) > abs(way.y):
			sprite.play("walk_right" if way.x > 0 else "walk_left")
		else:
			sprite.play("walk_down" if way.y > 0 else "walk_up")
	else:
		sprite.play("idle")

	move_and_slide(velocity)

# =====================================
# WORLD 2 – PLATFORMER (GRAVITY + JUMP + ANIMATIONS)
# =====================================
func platformer_mode(delta):
	var input_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = input_direction * speed

	velocity.y += gravity * delta

	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		$jump.play()
		velocity.y = -jump_speed

	velocity = move_and_slide(velocity, UP)

	# =====================================
	# FALL CHECK (Game Over if falling off)
	# =====================================
	if global_position.y > world_limit:
		Gamestate._fall_hurt()

	# =====================================
	# ANIMATIONS
	# =====================================
	if not is_on_floor():
		# Air animations
		if velocity.y < 0:
			if sprite.animation != "jump":
				sprite.play("jump")
		else:
			if sprite.animation != "fall":
				sprite.play("fall")
	else:
		# Ground animations
		if input_direction > 0:
			if sprite.animation != "walk_right":
				sprite.play("walk_right")
		elif input_direction < 0:
			if sprite.animation != "walk_left":
				sprite.play("walk_left")
		else:
			if sprite.animation != "idle":
				sprite.play("idle")

# =====================================
# HURT FUNCTION (When player loses a life)
# =====================================
#func _hurt():
#	Global.lives -= 1
#	print("Lives left: ", Global.lives)
#
#	# Update the GUI with the new number of lives
#	if has_node("../gui/Label"):
#		var life_label = get_node("../gui/Label")
#		life_label.text = "Lives: %d" % Global.lives
#	else:
#		print("Label node not found!")
#
#	# If no lives left, go to the Game Over screen
#	if Global.lives <= 0:
#		get_tree().change_scene("res://scripts/gameover.tscn")
#	else:
#		# Play hurt animation
#		$hurt.play()
#
## =====================================
## FALL HURT FUNCTION (When falling off)
## =====================================
#func _fall_hurt():
#	Global.lives -= 1
#	print("Lives left: ", Global.lives)
#
#	# Update the GUI with the new number of lives
#	if has_node("../gui/Label"):
#		var life_label = get_node("../gui/Label")
#		life_label.text = "Lives: %d" % Global.lives
#	else:
#		print("Label node not found!")
#
#	# If no lives left, trigger Game Over screen
#	if Global.lives <= 0:
#		get_tree().change_scene("res://scripts/gameover.tscn")
#	else:
#		# Respawn the player at the starting position when falling off
#		position = Global.char_position  # Reset to starting position
#		velocity = Vector2.ZERO  # Stop movement to prevent further movement
#		$hurt.play()  # Assuming you have an animation called "hurt"

# =====================================
# SCENE TRANSITIONS
# =====================================
# Add your scene transitions here, as you had before
func _on_house2_body_entered(body):
	if body == self and Global.key_taken:
		Global.is_platformer = false  # Disable gravity for house interior
		get_tree().change_scene("res://scripts/house2interior.tscn")

func _on_Area2D_body_entered(body):
	if body == self:
		Global.global_position = Vector2(408, 472)
		Global.is_platformer = false  # Disable gravity for non-platformer scenes
		get_tree().change_scene("res://scripts/Background.tscn")

func _on_cave_body_entered(body):
	if body == self:
		Global.global_position = Vector2(64, 256)
		Global.is_platformer = true  # Enable gravity for cave (platformer scene)
		get_tree().change_scene("res://scripts/caveinterior.tscn")

func _on_caveout_body_entered(body):
	if body == self:
		Global.global_position = Vector2(1544, 688)
		Global.is_platformer = false  # Disable gravity when leaving platformer scene
		get_tree().change_scene("res://scripts/Background.tscn")

func _on_StaticBody2D2_body_entered(body):
	if body == self:
		Global.global_position = Vector2(1136, 424)
		Global.is_platformer = false  # Disable gravity for non-platformer scenes
		get_tree().change_scene("res://scripts/Background.tscn")

func _on_gate_body_entered(body):
	if body == self:
		Global.global_position = Vector2(-3, 60)
		Global.is_platformer = true  # Enable gravity for platformer scene
		get_tree().change_scene("res://scripts/tiles.tscn")

func _on_out_body_entered(body):
	if body == self:
		Global.global_position = Vector2(1384, 568)
		Global.is_platformer = false  # Disable gravity for non-platformer scenes
		get_tree().change_scene("res://scripts/Background.tscn")
		
func _on_checkpoint_body_entered(body):
	if body.is_in_group("Player"): 
		get_tree().call_group("Gamestate", "set_checkpoint", body.global_position)
		print("Checkpoint reached! Position saved: ", body.global_position)
		set_deferred("monitoring", false)


