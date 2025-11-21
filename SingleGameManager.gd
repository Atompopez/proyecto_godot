extends Node
var point_label 
var texture_progress_bar
var puntos = 0
var sound_coin

func _ready():
	point_label = get_node("/root/Ui/Panel/PointsLabel")
	texture_progress_bar = get_node("/root/Ui/Panel/TextureRect2/TextureProgressBar")
	sound_coin = get_node("/root/Ui/CoinSound")

func add_puntos(body: Node2D):
	puntos += 1
	point_label.text = str(puntos) + " "
	texture_progress_bar.value += 3
	sound_coin.playing = true
