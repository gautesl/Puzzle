extends Sprite

var player = null
onready var size = get_viewport().get_visible_rect().size

func _ready():
	size.y -= 75

func _process(delta):
	visible = false
	var pos = player.position
	var local = Vector2()
	
	if pos.x > size.x:
		local.x = -(pos.x - size.x)
	if pos.x < 0: local.x = -pos.x
	if pos.y > size.y:
		local.y = -(pos.y - size.y)
	if pos.y < 0: local.y = -pos.y
	if local != Vector2():
		visible = true
		self.position = local
		look_at(player.position + Vector2(0, +75))
		rotation_degrees -= 90
