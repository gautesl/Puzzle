extends MarginContainer

onready var music_button = get_node("Border/Items/MusicButton")
onready var music_slider = get_node("Border/Items/MusicVolume/MusicSlider")
onready var sound_button = get_node("Border/Items/SoundButton")
onready var sound_slider = get_node("Border/Items/SoundVolume/SoundSlider")
onready var speed_slider = get_node("Border/Items/PlayerSpeed/SpeedSlider")

func _ready():
	music_button.pressed = get_node("../AudioStreamPlayer").playing
	music_button.connect("toggled", self, "set_music")
	if not music_button.pressed:
		get_node("Border/Items/MusicVolume").hide()
	
	music_slider.value = get_node("../AudioStreamPlayer").volume_db
	music_slider.connect("value_changed", self, "set_music_volume")
	
	sound_button.pressed = get_parent().sound_effects
	sound_button.connect("toggled", self, "set_sound")
	if not sound_button.pressed:
		get_node("Border/Items/SoundVolume").hide()
	
	sound_slider.value = get_node("../SoundEffects/Victory").volume_db
	sound_slider.connect("value_changed", self, "set_effect_volume")
	
	speed_slider.value = int(ceil((get_parent().player_speed_modifier - 1) * 10))
	speed_slider.connect("value_changed", self, "set_player_speed")

func set_music(toggled):
	get_node("../AudioStreamPlayer").playing = toggled
	get_node("Border/Items/MusicVolume").visible = toggled

func set_player_speed(speed):
	get_parent().player_speed_modifier = (float(speed) / 10) + 1

func set_music_volume(volume):
	get_node("../AudioStreamPlayer").volume_db = volume

func set_sound(toggled):
	get_parent().sound_effects = toggled
	get_node("Border/Items/SoundVolume").visible = toggled

func set_effect_volume(volume):
	for player in get_node("../SoundEffects").get_children():
		player.volume_db = volume