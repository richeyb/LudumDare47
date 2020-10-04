extends KinematicBody

var move_speed = 5
var patrol_path
var patrol_points
var patrol_index = 0

func _ready():
	patrol_path = get_node("Path") as Path
	if patrol_path:
		patrol_points = patrol_path.curve.get_baked_points()
		
func _physics_process(delta):
	if !patrol_path || patrol_points.size() <= 0:
		return
	var position = translation
	var target = patrol_points[patrol_index]
	if position.distance_to(target) < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	var velocity = (target - position).normalized() * move_speed
	velocity = move_and_slide(velocity)
	transform.origin.y = 1.0
