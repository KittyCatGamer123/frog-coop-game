@tool
class_name Lever extends StaticBody2D

var Activated: bool = false

var level_scene: Level = null

enum orientation_types { Ceiling, Right, Left } 

@export var LeverOrientation := orientation_types.Ceiling: 
	set(v): LeverOrientation = v; set_orientation(v);
	get: return LeverOrientation

# Incase you want a lever that stays active permenantly
@export var SingleUse: bool = false

@export var EnableList: Array[Node] = []
@export var DisableList: Array[Node] = []
@export var ToggleList: Array[Node] = []

@onready var lever_switch: Sprite2D = $LeverSwitch
@onready var lever_trigger: Area2D = $Area2D

const orientations = {
	orientation_types.Ceiling: {
		"rot": 0,
		"lb": Vector2(16,2),
		"ls": Vector2(16,8)
	},
	orientation_types.Right: {
		"rot": -90,
		"lb": Vector2(10,16),
		"ls": Vector2(4,16)
	},
	orientation_types.Left: {
		"rot": 90,
		"lb": Vector2(2,16),
		"ls": Vector2(8,16)
	}
} 

func set_orientation(v: orientation_types):
	var orien = orientations[v]
	$LeverBase.position = orien["lb"]
	$CollisionShape2D.position = orien["lb"]
	$LeverSwitch.position = orien["ls"]
	$Area2D/CollisionShape2D.position = orien["ls"]
	
	$LeverBase.rotation_degrees = orien["rot"]
	$CollisionShape2D.rotation_degrees = orien["rot"]
	$LeverSwitch.rotation_degrees = orien["rot"]
	$Area2D/CollisionShape2D.rotation_degrees = orien["rot"]



func _ready() -> void:
	var scene = get_tree().current_scene
	if scene is Level:
		level_scene = scene



func lever_on() -> void:
	for en in EnableList:
		level_scene.enable_node(en)
	for di in DisableList:
		level_scene.disable_node(di)
	for to in ToggleList:
		level_scene.toggle_node(to)
	
	# Just for it to be obvious when it is/isn't activated when testing until we get the sprite in
	Activated = !Activated
	$LeverSwitch.modulate = Color.GREEN if Activated else Color.RED



func body_entered(body: Node2D) -> void:
	if body is Tongue:
		lever_on()
		return



func body_exited(body: Node2D) -> void:
	if SingleUse:
		return
