extends KinematicBody
class_name Impostor

onready var timer : Timer = get_node("Timer")

export var move_speed : float = 200

export var player_path : NodePath
var player : Player
export var my_name : String

#onready var wallchecker : StaticBody = get_node("WallChecker") as StaticBody

signal game_over

enum States {
	Wandering,
	Hunting,
	Looking,
	Paused
}

export var hunting_speed_factor : float = 1.5

var current_state : int = States.Wandering

var rotate : float = 0
var rotate_speed : float = 1.0

export var hunter_killer_distance : float = 10

onready var raycast : RayCast = get_node("RayCast") as RayCast
onready var groundcast  : RayCast = get_node("GroundCast") as RayCast

onready var green_model : Spatial = get_node("GreenModel") as Spatial
onready var white_model : Spatial = get_node("WhiteModel") as Spatial

export var gravity_factor : float = -2.0
export var nudge_toward_player_factor : int = 8

enum Colors {
	Green, White
}
export (Colors) var suit_color

func pause():
	current_state = States.Paused

func resume():
	current_state = States.Wandering

func _ready():
	if suit_color == Colors.Green:
		white_model.visible = false
		green_model.visible = true
	else:
		green_model.visible = false
		white_model.visible = true

func _physics_process(delta):
	translation.y = groundcast.get_collision_point().y
	
	if current_state == States.Paused:
		return
	elif current_state == States.Wandering:
		wander(delta)
	elif current_state == States.Hunting:
		hunt(delta)
	elif current_state == States.Looking:
		avoid_walls(delta)

func avoid_walls(delta : float) -> void:
	rotate_object_local(Vector3(0, 1, 0), 3.14 / 10)
	if raycast.is_colliding():
		var see_object = raycast.get_collider()
		if node_in_group(see_object, "walls"):
			var distance = translation.distance_to(see_object.translation)
			if distance > 5:
				current_state = States.Wandering
				restart_timer()
	
func node_in_group(node : Node, group : String) -> bool:
	var groups = node.get_groups()
	return (groups.find(group) != -1)

func wander(delta : float) -> void:
	rotation.y = lerp_angle(rotation.y, rotate, delta)
	var direction = Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), rotation.y)
	var velocity = direction * move_speed * delta
	move_and_slide_with_snap(velocity, Vector3(0, 1, 0))
	
func hunt(delta : float) -> void:
	# var velocity = (translation - player.translation).normalized() * move_speed * delta
	var velocity = (player.translation - translation).normalized() * move_speed * delta * hunting_speed_factor
	look_at(player.translation, Vector3(0, 1, 0))
	rotate_object_local(Vector3(0, 1, 0), 3.14)
	move_and_slide_with_snap(velocity, Vector3(0, 1, 0))
	
	var distance = (player.translation.distance_to(translation))
	
	if !i_can_see_player() && distance > hunter_killer_distance:
		current_state = States.Wandering
		_on_Timer_timeout()

func i_can_see_player() -> bool:
	if raycast.is_colliding():
		var see_object = raycast.get_collider()
		if see_object.get_name() != "Player" && player.crouching:
			current_state = States.Wandering
			_on_Timer_timeout()
			return false
		else:
			return true
	else:
		return true

func _on_Timer_timeout():
	restart_timer()
	
func set_player(the_player : Player) -> void:
	player = the_player
	
func restart_timer():
	var slot : int = randi() % nudge_toward_player_factor + 1
	if slot == 1 && player:
		print("nudged")
		look_at(player.translation, Vector3(0, 1, 0))
		rotate_object_local(Vector3(0, 1, 0), 3.14)
	else:
		rotate = randf() * 360
	var new_timer = randi() % 5 + 1
	timer.start(new_timer)

func _on_Area_body_entered(body : Node):
	if body.get_name() == "Player":
		print("Found the player!")
		player = body as Player
		if i_can_see_player():
			current_state = States.Hunting

func _on_GameOverArea_body_entered(body : Node):
	if body.get_name() == "Player":
		print("Game Over - You were caught")
		emit_signal("game_over")
	elif node_in_group(body, "walls"):
		print("I hit a wall")
		current_state = States.Looking
