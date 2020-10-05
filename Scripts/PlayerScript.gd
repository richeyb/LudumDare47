extends KinematicBody
class_name Player

export var move_speed : float = 5.0
export var rotate_speed : float = 3.0

export var crouching : bool = false

onready var animation_player : AnimationPlayer = get_node("AnimationPlayer") as AnimationPlayer
onready var footstep_player : AudioStreamPlayer3D = get_node("FootstepPlayer") as AudioStreamPlayer3D

onready var groundcast : RayCast = get_node("GroundCast") as RayCast

enum States {
	Normal, Paused
}
var current_state : int = States.Normal

func _ready():
	animation_player = get_node("AnimationPlayer")
	
func pause():
	current_state = States.Paused

func resume():
	current_state = States.Normal

func _physics_process(delta : float) -> void:
	if current_state == States.Paused:
		return
	translation.y = groundcast.get_collision_point().y
	
	var z_movement : float = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var rotate : float = Input.get_action_strength("left") - Input.get_action_strength("right")
	
	if Input.get_action_strength("crouch") >= 1:
		crouching = true
	else:
		crouching = false

	if crouching && z_movement == 0:
		animation_player.play("Crouch")
	elif z_movement != 0:
		animation_player.play("Walk")
	else:
		animation_player.play("Normal")
		animation_player.stop()
	
	rotation.y +=  rotate * rotate_speed * delta
	var direction : Vector3 = Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), rotation.y)
	var motion : Vector3 = direction * z_movement * delta * move_speed
	move_and_collide(motion)
