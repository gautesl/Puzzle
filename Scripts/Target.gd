extends Area2D

var occupied = false setget set_occupied
var id = 0
onready var root = get_tree().get_root().get_node("World")

func _ready():
	connect("body_entered", self, "on_body_enter")
	connect("body_exited", self, "on_body_exit")
	id = int(get_name().substr(6, len(get_name()) + 1)) - 1
	if id == -1: id = 0

func on_body_enter(body):
	if not body.is_in_group("Player") or occupied: return
	root.play_sound("GreenOn")
	root.call_deferred("set_target", id, true)
	self.occupied = true

func on_body_exit(body):
	if not body.is_in_group("Player"): return
	root.play_sound("GreenOff")
	root.set_target(id, false)
	self.occupied = false

func set_occupied(val):
	occupied = val
	if val: get_node("Sprite").set_modulate("ffffff")
	else: get_node("Sprite").set_modulate("afafaf")