extends MarginContainer

const required_levels = 12
const levels_per_stage = 16
var view_nr = 0 setget set_view
var unlocked_views = 0
var modulates = []
var levels = 0
onready var grid = get_node("VBoxContainer/HBoxContainer/GridContainer")

func _ready():
	levels = get_parent().max_levels
	modulates = get_parent().data["modulates"]
	unlocked_views = get_parent().levels_cleared() / required_levels
	var target = min(get_parent().max_levels, (unlocked_views + 1) * required_levels)
	var text = "%d/%d" % [get_parent().levels_cleared(), target]
	get_node("VBoxContainer/MarginContainer/NavButtons/MarginContainer/Progress").set_text(text)
	get_node("VBoxContainer/MarginContainer/NavButtons/Back").connect("pressed", self, "prev_view")
	get_node("VBoxContainer/MarginContainer/NavButtons/Next").connect("pressed", self, "next_view")
	self.view_nr = (get_parent().level - 1) / levels_per_stage

func prev_view():
	self.view_nr -= 1

func next_view():
	self.view_nr += 1

func set_view(val):
	view_nr = val
	get_parent().set_background(view_nr)
	get_parent().top_panel.mode(modulates[view_nr])
	for c in grid.get_children(): c.queue_free()
	var num_buttons = min(levels_per_stage, levels - (view_nr * levels_per_stage))
	for i in range(num_buttons):
		grid.add_child(create_button((view_nr * levels_per_stage) + i))
	
	var next = get_node("VBoxContainer/MarginContainer/NavButtons/Next")
	get_node("VBoxContainer/MarginContainer/NavButtons/Back").visible = view_nr != 0
	next.visible = view_nr != (levels - 1) / levels_per_stage
	next.disabled = view_nr == unlocked_views
	if next.disabled: 
		next.set_modulate("3f3f3f")
		next.set_tooltip("Complete more levels to unlock the next stage")
	else:
		next.set_modulate("ffffff")
		next.set_tooltip("Next stage")
	get_node("VBoxContainer/MarginContainer/NavButtons").set_modulate(modulates[view_nr])

func create_button(i):
	var button = Button.new()
	var label = Label.new()
	label.align = HALIGN_CENTER
	label.valign = VALIGN_BOTTOM
	label.size_flags_horizontal = 3
	label.set_custom_minimum_size(Vector2(120, 60))
	button.add_child(label)
	button.set_text(str(i + 1))
	button.set_modulate(modulates[view_nr])
	button.set_custom_minimum_size(Vector2(120, 60))
	button.connect("pressed", get_parent(), "set_level", [i + 1])
	if get_parent().completed[i] != -1:
			var time = get_parent().completed[i]
			label.set_text("%02d:%02d" % [time / 60, time % 60])
	return button