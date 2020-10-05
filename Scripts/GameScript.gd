extends Node
class_name GameScript

onready var player : Player = get_node("Player")
onready var impostor : Impostor = get_node("Impostor")
onready var impostor2 : Impostor = get_node("Impostor2")
var impostors : Array

var initial_player_position : Vector3
var initial_impostor_position : Vector3
var initial_impostor2_position : Vector3

export var vents : Array

onready var vent_cooldown : Timer = get_node("VentCooldown")

onready var download_panel : Panel = get_node("UI/DownloadPanel")
onready var download_progress : ProgressBar = get_node("UI/DownloadPanel/DownloadProgress")
onready var download_timer : Timer = get_node("DownloadTimer")
onready var download_label : Label = get_node("UI/DownloadPanel/DownloadLabel")
onready var logs_downloaded_display : Label = get_node("UI/LogsDownloaded")
onready var fade_to_black : TextureRect = get_node("UI/FadeToBlack")

onready var ui : CanvasLayer = get_node("UI")

var logs : int = 0
var downloading_from : DeadCrewmate
var sending_final_transmission : bool = false

var is_fading_in : bool = false
var is_fading_out : bool = false

var game_won : bool = false

func _ready():
	logs = 0
	game_won = false
	sending_final_transmission = false
	is_fading_in = false
	is_fading_out = false
	
	initial_player_position = player.translation
	initial_impostor_position = impostor.translation
	initial_impostor2_position = impostor2.translation
	
	impostor.set_player(player)
	impostor2.set_player(player)
	impostors = [impostor, impostor2]
	
	vents = get_tree().get_nodes_in_group("vents")
	print("Vents found:", vents.size())
	
func fade(delta):
	if is_fading_in:
		fade_to_black.modulate.a -= 1 * delta
		if fade_to_black.modulate.a <= 0:
			is_fading_in = false
			resume_game()
	elif is_fading_out:
		fade_to_black.modulate.a += 1 * delta
		if fade_to_black.modulate.a >= 1:
			if game_won:
				Global.goto_scene("res://Objects/victory-screen.tscn")
			else:
				reset_game()
			is_fading_in = true
			is_fading_out = false

func _process(delta):
	fade(delta)

func _on_Impostor_game_over():
	game_over()

func _on_Impostor2_game_over():
	game_over()

func game_over():
	pause_game()
	Global.add_death()
	is_fading_out = true
	print("Game over, resetting")

func reset_game():
	player.translation = initial_player_position
	impostor.translation = initial_impostor_position
	impostor2.translation = initial_impostor2_position
	vent_cooldown.stop()

func _on_vent_impostor_entered_vent(new_impostor, came_from):
	vent_teleport(new_impostor, came_from)

func _on_Vent_impostor_entered_vent(new_impostor, came_from):
	vent_teleport(new_impostor, came_from)
	
func vent_teleport(imp, came_from):
	print(vent_cooldown.time_left)
	if vent_cooldown.time_left > 0:
		return
	var cull_vent = vents.find(came_from)
	var culled_vents = vents.duplicate()
	culled_vents.remove(cull_vent)
	if culled_vents.size() == 0:
		return
	var new_vent = randi() % culled_vents.size()
	var goto_vent = culled_vents[new_vent]
	imp.translation = goto_vent.translation
	vent_cooldown.start(15)
	
func begin_download():
	download_panel.visible = true
	download_progress.value = 0
	download_timer.start(1)

func halt_download():
	download_panel.visible = false
	download_progress.value = 0
	download_timer.stop()
	
func download_completed():
	if sending_final_transmission:
		win_the_game()
	else:
		logs += 1
		halt_download()
		downloading_from.downloaded = true
		if logs >= 5:
			logs_downloaded_display.text = "Head to navigation to send crew logs to HQ..."
		else:
			logs_downloaded_display.text = "Logs Downloaded: " + String(logs) + "/5"

func win_the_game():
	print("You win!")
	download_timer.stop()
	download_panel.visible = false
	pause_game()
	game_won = true
	is_fading_out = true
	
func pause_game():
	player.pause()
	impostor.pause()
	impostor2.pause()
	
func resume_game():
	player.resume()
	impostor.resume()
	impostor2.resume()

func _on_deadcrewmate_begin_download(sender : DeadCrewmate) -> void:
	sending_final_transmission = false
	downloading_from = sender
	download_label.text = "Downloading crew logs..."
	begin_download()

func _on_DownloadTimer_timeout():
	if sending_final_transmission:
		download_progress.value += 5
	else:
		download_progress.value += 10
	if download_progress.value == 100:
		download_completed()

func _on_deadcrewmate_halt_download(sender):
	halt_download()
	downloading_from = null

func _on_CSGBox7_begin_transmission():
	if logs < 5:
		return
	sending_final_transmission = true
	download_label.text = "Sending crew logs to HQ..."
	begin_download()

func _on_CSGBox7_halt_transmission():
	sending_final_transmission = false
	halt_download()
