extends KinematicBody2D

export var north = Vector2(0, -1)
export var east = Vector2(1, 0)
export var south = Vector2(0, 1)
export var west = Vector2(-1, 0)
export var total_scale = Vector2(1, 1)

onready var arrow = get_node("Arrow")
export var speed = 100
export var constant_motion = Vector2()
var teleporting = false
onready var size = get_viewport().get_visible_rect().size - Vector2(0, 75)

func _ready():
	arrow.player = self
	var sprite = get_node("Sprite")
	var col = get_node("CollisionShape2D")
	sprite.set_scale(sprite.get_scale() * total_scale)
	col.set_scale(col.get_scale() * total_scale)

func _process(delta):
	var motion = constant_motion
	if Input.is_action_pressed("ui_up"):
		motion += north
	if Input.is_action_pressed("ui_right"):
		motion += east
	if Input.is_action_pressed("ui_down"):
		motion += south
	if Input.is_action_pressed("ui_left"):
		motion += west
	
	update_label()
	move_and_slide(motion * speed)

func update_label():
	var cord = "%.0f, %.0f" % [position.x, position.y]
	get_node("Coordinates").set_text(cord)
	
	var pos = Vector2(-43, 38) + arrow.position
	if position.x < 20:
		pos += Vector2(50, -38)
		if position.y < 20: pos += Vector2(0, 38)
		elif position.y > size.y - 20: pos += Vector2(0, -38)
	elif position.x > size.x - 20:
		pos += Vector2(-50, -38)
		if position.y < 20: pos += Vector2(0, 38)
		elif position.y > size.y - 20: pos += Vector2(0, -38)
	elif position.y > size.y - 20:
		pos += Vector2(0, -76)
	
	get_node("Coordinates").set_position(pos)

func cleanse():
	north = Vector2(0, -1)
	east = Vector2(1, 0)
	south = Vector2(0, 1)
	west = Vector2(-1, 0)
	constant_motion = Vector2()