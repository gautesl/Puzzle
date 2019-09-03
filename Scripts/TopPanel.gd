extends Panel

onready var back_button = get_node("MarginContainer/HBoxContainer/TextureButton")
onready var time_label = get_node("MarginContainer/HBoxContainer/TimeLabel")
onready var message_label = get_node("MarginContainer/HBoxContainer/CenterContainer/MsgLabel")
onready var timer = get_node("Timer")
onready var position_button = get_node("MarginContainer/HBoxContainer/CheckBox")
var messages = []
var msg_nr = 0

func _ready():
	back_button.connect("pressed", get_parent(), "set_scene", ["MainMenu"])
	timer.connect("timeout", self, "next_message")
	position_button.connect("toggled", get_parent(), "set_show_player_pos")

func message(msg):
	messages = msg
	if msg: message_label.set_text(msg[0])
	else: message_label.set_text("")
	

func set_time(time):
	time_label.set_text("%02d:%02d" % [time / 60, time % 60])

func mode(mode):
	visible = true
	position_button.visible = false
	timer.stop()
	if mode == "LevelSelect":
		message_label.set_text("Select a level")
		time_label.visible = false
		set_modulate("00abff")
	elif mode == "OptionMenu":
		message_label.set_text("Options")
		time_label.visible = false
		set_modulate("ffffff")
	elif mode == "Level":
		time_label.visible = true
		position_button.visible = true
		set_modulate("ffffff")
		msg_nr = 0
		timer.set_wait_time(10)
		timer.start()
	elif mode == "MainMenu":
		visible = false
	else:
		set_modulate(mode)

func next_message():
	if not messages: return
	msg_nr = (msg_nr + 1) % len(messages)
	message_label.set_text(messages[msg_nr])
	timer.set_wait_time(timer.get_wait_time() * 2)