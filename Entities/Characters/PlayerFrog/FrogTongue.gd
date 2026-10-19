extends CharacterBody2D
class_name Tongue

var tongue_path: Array[Vector2] = []
var tongue_of: String = "Tree"

@export var TongueSpeed = 300.0
@onready var player_frog: Frog = get_parent()
var alive: bool = true

func _ready() -> void:
	tongue_of = get_parent().frog_name
	tongue_path.append(player_frog.to_local(global_position))

func tongue_movement() -> void:
	var direction: float = Input.get_axis(tongue_of+"_left", tongue_of+"_right")
	if direction != 0:
		velocity.x = TongueSpeed * direction
		tongue_path.append(player_frog.to_local(global_position))
	else:
		velocity.x = 0
	
	var up_direction = Input.get_action_strength(tongue_of+"_jump")
	if up_direction == 1:
		velocity.y = TongueSpeed * -up_direction
		tongue_path.append(player_frog.to_local(global_position))
	else:
		velocity.y = 0

func destroy() -> void:
	if not alive:
		return
	
	alive = false
	tongue_path.reverse()
	
	while not tongue_path.is_empty():
		position = tongue_path[0]
		tongue_path.remove_at(0)
		await get_tree().create_timer(0).timeout
	
	player_frog.tongue_mode_active = false
	queue_free()

func _process(delta: float) -> void:
	player_frog.queue_redraw()
	
	if alive:
		tongue_movement()
		move_and_slide()
