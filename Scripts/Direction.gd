extends Area2D

export var direction = Vector2(0, -1)

func _ready():
	look_at(direction.rotated(PI / 2) * 100000)
	connect("body_entered", self, "on_body_enter")

func on_body_enter(body):
	if body.is_in_group("Player"):
		body.constant_motion = direction