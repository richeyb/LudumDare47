extends Node2D
class_name VictoryScreen

onready var victory_text : Label = get_node("CanvasLayer/DialogPanel/Label")

func _ready():
	victory_text.text = """
	You did it! You've managed to avoid the impostors, get the logs from your crewmates, and successfully dispatched them to HQ!
	
	After sending the logs, HQ triggered an anomalous time event remotely, sending you back before the reactor melt down.
	
	You passionately pleaded with the rest of your crew to eject white and green into space to save the rest of the ship and crew!
	
	It took a lot of convincing, but finally your crew listened, and the impostors were floated into space, their bodies deforming into
	hideous creatures in the vacuum of space. After the cheers and pats on the back from the rest of your crew, you could hear a
	comment under the breath of one of your fellow crewmates:
		
		
	\"...red still pretty sus though...\"
	"""
	
	victory_text.text += "\n\nYou looped " + String(Global.deaths) + " times!\n"

func _on_DialogCloseButton_pressed():
	Global.goto_scene("res://Objects/title-screen.tscn")
