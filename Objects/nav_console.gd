extends CSGBox

signal begin_transmission
signal halt_transmission

func _on_Area_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("begin_transmission")

func _on_Area_body_exited(body):
	if body.get_name() == "Player":
		emit_signal("halt_transmission")
