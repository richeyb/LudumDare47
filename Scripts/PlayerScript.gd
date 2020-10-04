extends KinematicBody
class_name Player

export var move_speed : float = 10.0
export var rotate_speed : float = 3.0
export var gravity_factor : float = -2.0

export var crouching : bool = false

onready var animation_player : AnimationPlayer = get_node("AnimationPlayer") as AnimationPlayer
onready var footstep_player : AudioStreamPlayer3D = get_node("FootstepPlayer") as AudioStreamPlayer3D

func _ready():
	footstep_player.playing = true
	footstep_player.stream_paused = true
	animation_player = get_node("AnimationPlayer")

func _physics_process(delta : float) -> void:
	var z_movement : float = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var rotate : float = Input.get_action_strength("left") - Input.get_action_strength("right")
	
	if Input.get_action_strength("crouch") >= 1:
		crouching = true
	else:
		crouching = false
		
	if crouching && z_movement == 0:
		animation_player.play("Crouch")
		footstep_player.stream_paused = true
	elif z_movement != 0:
		animation_player.play("Walk")
		footstep_player.stream_paused = false
	else:
		animation_player.play("Normal")
		animation_player.stop()
		footstep_player.stream_paused = true
	
	rotation.y +=  rotate * rotate_speed * delta
	var direction : Vector3 = Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), rotation.y)
	var gravity : Vector3 = do_the_gravity(delta)
	var motion : Vector3 = direction * z_movement * delta * move_speed
	motion += do_the_gravity(delta)
	move_and_collide(motion)

func do_the_gravity(delta : float) -> Vector3:
	var motion : Vector3 = Vector3(0, gravity_factor, 0) * delta
	return motion
