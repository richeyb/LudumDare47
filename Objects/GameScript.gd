extends Node
class_name GameScript

onready var player : Player = get_node("Player")
onready var impostor : Impostor = get_node("Impostor")
onready var impostor2 : Impostor = get_node("Impostor2")

var initial_player_position : Vector3
var initial_impostor_position : Vector3
var initial_impostor2_position : Vector3

export var vents : Array

onready var vent_cooldown : Timer = get_node("VentCooldown")

func _ready():
	initial_player_position = player.translation
	initial_impostor_position = impostor.translation
	initial_impostor2_position = impostor2.translation
	
	impostor.set_player(player)
	impostor2.set_player(player)
	
	vents = get_tree().get_nodes_in_group("vents")
	print("Vents found:", vents.size())

func _on_Impostor_game_over():
	game_over()

func _on_Impostor2_game_over():
	game_over()

func game_over():
	player.translation = initial_player_position
	impostor.translation = initial_impostor_position
	impostor2.translation = initial_impostor2_position
	vent_cooldown.stop()
	print("Game over, resetting")

func _on_vent_impostor_entered_vent(new_impostor, came_from):
	vent_teleport(new_impostor, came_from)

func _on_Vent_impostor_entered_vent(new_impostor, came_from):
	vent_teleport(new_impostor, came_from)
	
func vent_teleport(imp, came_from):
	print(vent_cooldown.time_left)
	if vent_cooldown.time_left > 0:
		return
	print("Received vent")
	var cull_vent = vents.find(came_from)
	var culled_vents = vents.duplicate()
	culled_vents.remove(cull_vent)
	if culled_vents.size() == 0:
		return
	var new_vent = randi() % culled_vents.size()
	var goto_vent = culled_vents[new_vent]
	imp.translation = goto_vent.translation
	vent_cooldown.start(15)
