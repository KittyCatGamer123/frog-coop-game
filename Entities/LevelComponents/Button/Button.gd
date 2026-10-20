@tool
extends StaticBody2D
class_name LevelButton

var Activated: bool = false

var level_scene: Level = null
enum orientation_types { Floor, Ceiling, Right, Left } 

## The direction the button faces in the scene.
@export var ButtonOrientation := orientation_types.Ceiling: 
	set(v): ButtonOrientation = v; set_orientation(v);
	get: return ButtonOrientation

## Button cannot be hit by a player again after it's been pressed.
@export var SingleUse: bool = true

## Player standing on or hitting their body off the button will trigger the button.
## Disable if you only want the tongue to activate it.
@export var AllowBodyPress: bool = false

@export var EnableList: Array[Node] = []
@export var DisableList: Array[Node] = []
@export var ToggleList: Array[Node] = []

@onready var button_plate: Sprite2D = $ButtonPlate
@onready var button_trigger: Area2D = $Area2D

const orientations = {
	orientation_types.Ceiling: {
		"rot": 0,
		"bh": Vector2(16,2),
		"bp": Vector2(16,6)
	},
	orientation_types.Floor: {
		"rot": 0,
		"bh": Vector2(16,14),
		"bp": Vector2(16,10)
	},
	orientation_types.Right: {
		"rot": -90,
		"bh": Vector2(6,16),
		"bp": Vector2(2,16)
	},
	orientation_types.Left: {
		"rot": 90,
		"bh": Vector2(2,16),
		"bp": Vector2(6,16)
	}
} 

func set_orientation(v: orientation_types):
	var orien = orientations[v]
	$ButtonHolder.position = orien["bh"]
	$CollisionShape.position = orien["bh"]
	$ButtonPlate.position = orien["bp"]
	$Area2D/CollisionShape2D.position = orien["bp"]
	
	$ButtonHolder.rotation_degrees = orien["rot"]
	$CollisionShape.rotation_degrees = orien["rot"]
	$ButtonPlate.rotation_degrees = orien["rot"]
	$Area2D/CollisionShape2D.rotation_degrees = orien["rot"]

func _ready() -> void:
	var scene = get_tree().current_scene
	if scene is Level:
		level_scene = scene

func button_activate() -> void:
	button_plate.visible = false
	
	for en in EnableList:
		level_scene.enable_node(en)
	for di in DisableList:
		level_scene.disable_node(di)
	for to in ToggleList:
		level_scene.toggle_node(to)

func on_body_entered(body: Node2D) -> void:
	if body is Tongue:
		button_activate()
		return
	
	if (body is Frog) and (AllowBodyPress):
		button_activate()
		return

func on_body_exit(body: Node2D) -> void:
	if SingleUse:
		return
	
	if (body is Tongue) or ((body is Frog) and (AllowBodyPress)):
		button_plate.visible = true
