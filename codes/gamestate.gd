extends Node

# ---------- Player state ----------
var can_take_damage = true
var live = 3  # Start with 4 lives
var current_checkpoint = Vector2.ZERO
var player_position = Vector2(0,0)

# GUI reference (optional if using call_group)
# var gui_node = null
func reset_lives():
	live = 3
	get_tree().call_group("GUI", "_update_gui", live)
	current_checkpoint = Vector2.ZERO

func _ready():
	add_to_group("Gamestate")
	# Update GUI at start
	get_tree().call_group("GUI", "_update_gui", live)

# ---------- Checkpoint ----------
func set_checkpoint(pos: Vector2):
	current_checkpoint = pos
	print("Checkpoint set at: ", current_checkpoint)

# ---------- Respawn ----------
func respawn_player(player):
	if player == null:
		return
	
	if current_checkpoint != Vector2.ZERO:
		player.global_position = current_checkpoint
	else:
		# DEFAULT START POSITION
		player.global_position = player.start_position 

	player.velocity = Vector2.ZERO

# ---------- Lose life ----------*
func lose_life(respawn_the_player = true):
	if !can_take_damage:
		return

	can_take_damage = false
	live -= 1

	get_tree().call_group("GUI", "_update_gui", live)

	if live <= 0:
		_game_over()
	else:
		if respawn_the_player:
			var players = get_tree().get_nodes_in_group("KinematicBody2D")
			if players.size() > 0:
				respawn_player(players[0])

	yield(get_tree().create_timer(.5), "timeout")
	can_take_damage = true

# ---------- Player fell ----------
func _fall_hurt():
	var players = get_tree().get_nodes_in_group("Player")
	
	if players.size() > 0:
		var player = players[0]
		respawn_player(player)

	lose_life(false)

# ---------- Player hit by hazard ----------
func hurt_player():
	lose_life(true)

# ---------- Game over ----------
func _game_over():
	reset_lives()
	get_tree().change_scene("res://scripts/gameover.tscn")
