extends Node2D
var ui_node
var game_sound

func _ready():
	ui_node = get_node("/root/Ui")
	game_sound = get_node("/root/Ui/GameAudio")
	ui_node.hide()
	game_sound.playing = false
	
func _exit_tree():
	ui_node.show()
	game_sound.playing = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://nivel1.tscn")

func _on_button2_pressed() -> void:
	get_tree().change_scene_to_file("res://nivel2.tscn")
