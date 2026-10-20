@tool
extends CharacterBody2D
class_name Frog

var is_editor = false
enum FrogType { TREE, WATER }
const type_name = { FrogType.TREE: "tree", FrogType.WATER: "water" }
var frog_name = "tree"

var tongue_mode_active: bool = false
var tongue_object: Tongue = null
@onready var tongue_leftpos: Vector2 = $SpawnTongueLeft.position
@onready var tongue_rightpos: Vector2 = $SpawnTongueRight.position

@onready var sprite_frames = $SpriteFrames
@onready var player_above_cast = $PlayerAboveCast
@onready var area_collider: Area2D = $Area2D
@onready var tongue_length_label: Label = $RemainingLength
var tongue_scene = load("res://Entities/Characters/Tongue/Tongue.tscn")

@export var Type := FrogType.TREE: 
	set(v): Type = v; set_frog(v);
	get: return Type
@export var MovementSpeed: float = 250.0
@export var JumpForce: float = -300.0
@export var TongueLengthLimit: int = 25
var in_water: bool = false

func _ready() -> void:
	is_editor = Engine.is_editor_hint()
	sprite_frames.flip_h = (global_position.x >= 0)
	tongue_length_label.text = str(TongueLengthLimit)
	set_frog(Type)

func set_frog(type: FrogType) -> void:
	frog_name = type_name[type]
	if sprite_frames:
		sprite_frames.play(frog_name)

func player_movement() -> void:
	var direction: float = Input.get_axis(frog_name+"_left", frog_name+"_right")
	if direction != 0:
		velocity.x = MovementSpeed * direction
		animation_frame_update(direction)
	else:
		velocity.x = 0

func player_jump() -> void:
	if (not is_on_floor()) and (not in_water):
		return
	
	if player_above_cast.is_colliding():
		var above_frog = player_above_cast.get_collider()
		if above_frog is Frog:
			above_frog.player_jump()
	
	velocity.y = JumpForce

func animation_frame_update(direction) -> void:
	sprite_frames.flip_h = (direction == -1)

func _physics_process(delta: float) -> void:
	if is_editor:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed(frog_name+"_tongue"):
		if tongue_mode_active:
			tongue_object.destroy()
		else:
			velocity.x = 0
			tongue_object = tongue_scene.instantiate()
			tongue_mode_active = true
			add_child(tongue_object)
			
			var spawn_pos = tongue_leftpos if sprite_frames.flip_h else tongue_rightpos
			tongue_object.position = spawn_pos
	
	in_water = false
	for n in area_collider.get_overlapping_areas():
		if n is LevelLiquid:
			if n.Type == LevelLiquid.LiquidType.WATER:
				in_water = true
				break
	
	if not tongue_mode_active:
		if Input.is_action_just_pressed(frog_name+"_jump"):
			player_jump()
		player_movement()
	
	if tongue_mode_active:
		tongue_length_label.text = str(TongueLengthLimit - len(tongue_object.tongue_path))
	
	move_and_slide()

func _draw() -> void:
	if tongue_object == null:
		return
	
	if tongue_object.tongue_path.size() < 2:
		return
	
	for i in range(1, tongue_object.tongue_path.size()):
		draw_line(tongue_object.tongue_path[i - 1], tongue_object.tongue_path[i], Color("#ff7373"), 1.5, true)
