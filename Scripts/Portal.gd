extends Area2D

export(NodePath) var other
export(Array, NodePath) var others = []
export(Array, NodePath) var lock_ref = []
onready var root = get_tree().get_root().get_node("World")
var portal
var portal_index = 0
var locks = 0 setget set_locks
var max_locks = 0
var occupied = false
var not_locked = true

func _ready():
	connect("body_entered", self, "teleport")
	connect("body_exited", self, "exit")
	if others:
		portal = get_node(others[0])
	else: portal = get_node(other)
	if lock_ref:
		for lock in lock_ref:
			get_node(lock).portal = self
			max_locks += 1
	self.locks = 0

func teleport(body):
	if can_teleport(body):
		body.teleporting = true
		var disc = position - body.position
		body.position = portal.position - disc
		portal.occupied = true
		if others:
			portal_index = (portal_index + 1) % len(others)
			portal = get_node(others[portal_index])
		root.play_sound("Teleport")

func can_teleport(body):
	return body.is_in_group("Player") and \
	       not body.teleporting and \
	       not portal.occupied and \
	       not_locked

func exit(body):
	if body.is_in_group("Player"):
		body.teleporting = false
		occupied = false

func set_locks(val):
	locks = val
	not_locked = locks == max_locks
	get_node("Locked").visible = not not_locked
	if not_locked:
		for b in get_overlapping_bodies():
			teleport(b)