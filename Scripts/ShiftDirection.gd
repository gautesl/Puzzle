extends Area2D

export(Array, NodePath) var rotators = []

func _ready():
	connect("body_entered", self, "shift_direction")

func shift_direction(body):
	if body.is_in_group("Player"):
		for rotator in rotators:
			get_node(rotator).shift_direction()
		get_node("Countercloclwise_sprite").visible = not get_node("Countercloclwise_sprite").visible