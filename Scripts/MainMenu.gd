extends MarginContainer

func _ready():
	get_node("VBoxContainer/Play").connect("pressed", get_parent(), "set_level", [get_parent().level])
	get_node("VBoxContainer/Levels").connect("pressed", get_parent(), "set_scene", ["LevelSelect"])
	get_node("VBoxContainer/Options").connect("pressed", get_parent(), "set_scene", ["OptionMenu"])
	get_node("VBoxContainer/Exit").connect("pressed", self, "quit")

func quit():
	get_tree().quit()