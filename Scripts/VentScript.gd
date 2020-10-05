extends Spatial
class_name Vent

signal impostor_entered_vent(impostor, came_from)

func _on_TeleportArea_body_entered(body : Node):
	var name = body.get_name()
	if  name.begins_with("Impostor"):
		emit_signal("impostor_entered_vent", body, self)
	
func node_in_group(node : Node, group : String) -> bool:
	var groups = node.get_groups()
	return (groups.find(group) != -1)
