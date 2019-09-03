extends Area2D

onready var root = get_tree().get_root().get_node("World")

func _ready():
	connect("body_entered", self, "restart")

func restart(body):
	if body.is_in_group("Player"):
		root.play_sound("Restart")
		root.call_deferred("set_level", root.level)

