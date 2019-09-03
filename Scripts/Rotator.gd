extends Node2D

export(float) var speed = 1
export var clockwise = true

func _ready():
	pass

func _process(delta):
	if clockwise: rotate(speed / (PI * 10))
	else: rotate(speed / (PI * -10))

func shift_direction():
	clockwise = not clockwise