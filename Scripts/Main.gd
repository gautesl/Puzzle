extends Node2D

# Sprites downloaded from https://game-icons.net
# made by Delapouite, Lorc, sbed

# Music: Eric Skiff - Come And Find Me, Underclocked, We're the Resistors -
# Resistor Anthems - Available at http://EricSkiff.com/music

var level = 1 setget set_level
var max_levels = 0
var completed = []
var targets = []
var data = {}
var time = 0 
var music_nr = 0
var player_speed_modifier = 1.2
var sound_effects = true
var show_player_pos = false setget set_show_player_pos
onready var root = get_tree().get_root().get_node("World")
onready var top_panel = get_node("TopPanel")
onready var scene = null setget set_scene

func _ready():
	# Center screen
	var pos = OS.get_screen_size() * 0.5 - OS.get_window_size() * 0.5
	OS.set_window_position(pos + Vector2(0, -30))
	
	# Find amount of levels created
	var dir = Directory.new()
	dir.open("res://Scener/Levels")
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if not file.begins_with("."):
			max_levels += 1
		file = dir.get_next()
	dir.list_dir_end()
	
	# Parse data from json-file
	file = File.new()
	file.open("res://Texts/data.json", file.READ)
	data = parse_json(file.get_as_text())
	file.close()
	
	# Set up main menu
	scene = load("res://Scener/MainMenu.tscn").instance()
	root.add_child(scene)
	
	# signals
	get_node("Timer").connect("timeout", self, "update_time")
	
	# Set up times
	for i in range(max_levels):
		completed.append(-1)
	
	# Set up music
	get_node("AudioStreamPlayer").connect("finished", self, "next_song")

func _input(event):
	if event.is_action_pressed("ui_accept") and scene.is_in_group("Level"):
		self.level = level
	elif event.is_action_pressed("ui_cheat"):
		for i in range(max_levels): 
			completed[i] = 1000
		if scene.is_in_group("Level"):
			for p in scene.get_node("Players").get_children():
				p.speed += 50
		elif scene.is_in_group("LevelSelect"):
			set_scene("LevelSelect")
	elif event.is_action_pressed("ui_return"):
		if scene.is_in_group("Level"):
			set_scene("LevelSelect")
		else: set_scene("MainMenu")

func set_level(n):
	level = n
	set_background((n - 1) / 16)
	self.scene = "Levels/Level" + str(n)
	get_node("FadeScreen/AnimationPlayer").play("Fade")

func set_scene(name):
	get_node("Timer").stop()
	root.remove_child(scene)
	scene.call_deferred("free")
	scene = load("res://Scener/" + name + ".tscn").instance()
	root.add_child(scene)
	scene.set_draw_behind_parent(true)
	if scene.is_in_group("Level"):
		setup_level()
	else: 
		top_panel.mode(name)
		targets = [false]

func setup_level():
	targets = []
	for i in range(len(scene.get_node("Targets").get_children())):
		targets.append(false)
	for player in scene.get_node("Players").get_children():
		player.speed *= player_speed_modifier
	if scene.has_node("Movables"):
		for object in scene.get_node("Movables").get_children():
			object.speed *= player_speed_modifier
	update_time(0)
	get_node("Timer").start()
	self.show_player_pos = show_player_pos
	top_panel.mode("Level")
	if level <= len(data["messages"]): top_panel.message(data["messages"][level-1])
	else: top_panel.message([])

func set_target(i, val):
	targets[i] = val
	for b in targets:
		if not b: return
	clear_level(level)

func levels_cleared():
	var num = 0
	for t in completed:
		if t != -1:
			num += 1
	return num

func clear_level(n):
	play_sound("Victory")
	if completed[n-1] == -1 or time < completed[n-1]:
		completed[n-1] = time
	
	var views_unlocked = 1 + levels_cleared() / 12
	if level < views_unlocked * 16 and level < max_levels:
		self.level += 1
	else:
		set_scene("LevelSelect")

func update_time(value=-1):
	if value != -1: time = value
	else: time += 1
	top_panel.set_time(time)

func set_background(view_nr):
	var image = load("res://Sprites/Backgrounds/" + data["backgrounds"][view_nr])
	get_node("CanvasLayer/Sprite").set_texture(image)

func next_song():
	music_nr = (music_nr + 1) % len(data["music"])
	get_node("AudioStreamPlayer").stream = load(data["music"][music_nr])
	get_node("AudioStreamPlayer").play()

func play_sound(name):
	if not sound_effects: return
	get_node("SoundEffects/" + name).play()

func set_show_player_pos(toggled):
	show_player_pos = toggled
	for player in scene.get_node("Players").get_children():
		player.get_node("Coordinates").visible = toggled