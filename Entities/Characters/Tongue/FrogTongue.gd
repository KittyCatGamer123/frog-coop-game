extends CharacterBody2D
class_name Tongue

var tongue_path: Array[Vector2] = []
var tongue_of: String = "Tree"
var tongue_limit: int = -1

@export var TongueSpeed = 300.0
@onready var player_frog: Frog = get_parent()
var alive: bool = true

func _ready() -> void:
	tongue_of = player_frog.frog_name
	tongue_limit = player_frog.TongueLengthLimit
	add_position_to_path()

func tongue_movement() -> void:
	if len(tongue_path) >= tongue_limit:
		velocity = Vector2.ZERO
		return
	
	var direction: float = Input.get_axis(tongue_of+"_left", tongue_of+"_right")
	if direction != 0:
		velocity.x = TongueSpeed * direction
		add_position_to_path()
	else:
		velocity.x = 0
	
	var updir = Input.get_action_strength(tongue_of+"_jump")
	if updir == 1:
		velocity.y = TongueSpeed * -updir
		add_position_to_path()
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

func add_position_to_path() -> void:
	var new_pos = player_frog.to_local(global_position)
	if len(tongue_path) == 0:
		tongue_path.append(new_pos)
		return
	
	if tongue_path[-1] != new_pos:
		tongue_path.append(new_pos)

func _physics_process(_delta: float) -> void:
	player_frog.queue_redraw()
	
	if alive:
		tongue_movement()
		move_and_slide()
