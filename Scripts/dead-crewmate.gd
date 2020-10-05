extends Spatial
class_name DeadCrewmate

signal begin_download(sender)
signal halt_download(sender)

enum Colors {
	Blue, Pink, Orange, Brown, Yellow
}
export (Colors) var my_color : int

export var downloaded : bool = false

onready var blue : Spatial = get_node("blue")
onready var pink : Spatial = get_node("pink")
onready var orange : Spatial = get_node("orange")
onready var brown : Spatial = get_node("brown")
onready var yellow : Spatial = get_node("yellow")
onready var colors : Array = [blue, pink, orange, brown, yellow]

func _ready():
	for color in colors:
		color.visible = false
	colors[my_color].visible = true

func _on_DownloadArea_body_entered(body):
	if body.get_name() == "Player" && !downloaded:
		emit_signal("begin_download", self)

func _on_DownloadArea_body_exited(body):
	if body.get_name() == "Player" && !downloaded:
		emit_signal("halt_download", self)
