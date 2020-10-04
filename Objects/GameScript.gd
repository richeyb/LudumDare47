extends Node
class_name GameScript

onready var player : Player = get_node("Player")
onready var impostor : Impostor = get_node("Impostor")
var initial_player_position : Vector3
var initial_impostor_position : Vector3

func _ready():
	initial_player_position = player.translation
	initial_impostor_position = impostor.translation

func _on_Impostor_game_over():
	player.translation = initial_player_position
	impostor.translation = initial_impostor_position
	print("Game over, resetting")
