extends Area2D

export var turn = Vector2(-1, -1)
export var forced_dir = Vector2()
export var change_constant_motion = true
onready var root = get_tree().get_root().get_node("World")

func _ready():
	connect("body_entered", self, "on_body_enter")

func on_body_enter(body):
	if not body.is_in_group("Player"): return
	if forced_dir:
		if forced_dir.y != 0:
			body.north = forced_dir
			body.south = forced_dir
		if forced_dir.x != 0:
			body.east = forced_dir
			body.west = forced_dir
	else:
		body.north *= turn
		body.east *= turn
		body.south *= turn
		body.west *= turn
	if change_constant_motion:
		body.constant_motion *= turn
	root.play_sound("Turn")