extends Node
class_name GameScript

onready var player : Player = get_node("Player")
onready var impostor : Impostor = get_node("Impostor")
onready var impostor2 : Impostor = get_node("Impostor2")

var initial_player_position : Vector3
var initial_impostor_position : Vector3
var initial_impostor2_position : Vector3

func _ready():
	initial_player_position = player.translation
	initial_impostor_position = impostor.translation
	initial_impostor2_position = impostor2.translation
	
	impostor.set_player(player)
	impostor2.set_player(player)

func _on_Impostor_game_over():
	game_over()

func _on_Impostor2_game_over():
	game_over()

func game_over():
	player.translation = initial_player_position
	impostor.translation = initial_impostor_position
	impostor2.translation = initial_impostor2_position
	print("Game over, resetting")
