extends Area2D

func _ready():
	connect("body_entered", self, "cleanse")

func cleanse(body):
	if body.is_in_group("Player"):
		body.cleanse()
