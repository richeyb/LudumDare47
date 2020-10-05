extends Node2D
class_name TitleScreen

onready var dialog_panel : Panel = get_node("CanvasLayer/DialogPanel")
onready var dialog_text : Label = get_node("CanvasLayer/DialogPanel/Label")

func _on_Button_pressed():
	Global.goto_scene("res://Objects/DemoScene.tscn")

func _on_ControlsButton_pressed():
	dialog_panel.visible = true
	dialog_text.text = """
		CONTROLS
		-----------------------------
		
		Controlling the player:
			
		   [W]
		[A]   [S]
		   [D]
		
		[C] - Crouch
		
		-----------------------------
		
		Interacting with objects:
		
		- Approach the body of a crewmate to download their logs
		- Approach the red button in Navigation to send the final transmission and win the game!
	"""

func _on_DialogCloseButton_pressed():
	dialog_panel.visible = false

func _on_StoryButton_pressed():
	dialog_panel.visible = true
	dialog_text.text = """
		Your ship is the Hyperloop Epsilon.
		
		The last thing you can remember is sirens...the reactor was melting down. You and your crew, well,
		most of your crew, ran to the reactor to see what was happening.
		
		The crewmates in yellow and brown shouted orders at everyone, directing people to restart settings,
		unplug and plug in the various equipment, and fix the damaged wiring.
		
		You were assigned the wiring, and the last thing you remember, besides the distinct lack of the
		crewmates in green and white, was accidentally connecting the blue wire to the green wire.
		
		From what you remember of the brief training session before you set off in this experimental
		time-powered spaceship, some events can trigger a time loop event. The time loop event could be
		catastrophic to the safety of the entire crew and ship, and the consequences are at best theoretical.
		
		You suspect you've been in this loop before, and that you'll be in this loop again. If you can at
		least send a message to HQ, maybe they can help you stop the events.
		
		----
		
		You wake up in a daze in the medical bay, not sure what to do next...a corpse lies in front of you,
		so maybe you can download the logs from their transmitter and send those to HQ?
		
		But you're not alone...you hear...footsteps and snarling in the distant darkness.
		
		Your only comfort is that if you die, maybe you'll trigger a time loop and get a chance to make things
		right for your mistake...
	"""

func _on_QuitButton_pressed():
	get_tree().quit()
