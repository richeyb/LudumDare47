extends KinematicBody
class_name Player

export var move_speed : float = 10.0
export var rotate_speed : float = 3.0
export var gravity_factor : float = -2.0

onready var animation_player : AnimationPlayer = get_node("AnimationPlayer") as AnimationPlayer

func _ready():
	animation_player = get_node("AnimationPlayer")

func _physics_process(delta : float) -> void:
	var z_movement : float = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var rotate : float = Input.get_action_strength("left") - Input.get_action_strength("right")
	
	if z_movement != 0:
		animation_player.play("Walking")
	else:
		animation_player.play("Idle")
		animation_player.stop()
	
	rotation.y +=  rotate * rotate_speed * delta
	var direction : Vector3 = Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), rotation.y)
	var gravity : Vector3 = do_the_gravity(delta)
	var motion : Vector3 = direction * z_movement * delta * move_speed
	motion += do_the_gravity(delta)
	move_and_collide(motion)

func do_the_gravity(delta : float) -> Vector3:
	var motion : Vector3 = Vector3(0, gravity_factor, 0) * delta
	return motion
