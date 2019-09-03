extends Area2D

var portal

func _ready():
	connect("body_entered", self, "on_body_enter")
	connect("body_exited", self, "on_body_exited")

func on_body_enter(body):
	if body.is_in_group("Player"):
		portal.locks += 1
		get_node("Sprite").set_modulate("ffffff")

func on_body_exited(body):
	if body.is_in_group("Player"):
		portal.locks -= 1
		get_node("Sprite").set_modulate("8b8b8b")

func is_locked():
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			return true
	return false
