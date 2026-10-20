extends Node2D
class_name Level

## List of all objects that are disabled when the room starts.
## They get activated using buttons or other group togglers.
var NodesDisabled: Array[Node] = []
@export var NodesDisabledOnStart: Array[Node] = []

func _ready() -> void:
	disable_nodes_in_list()

func toggle_node(obj: Node) -> void:
	if obj in NodesDisabled:
		enable_node(obj)
	else:
		disable_node(obj)

func enable_node(obj: Node) -> void:
	if obj is TileMapLayer:
		obj.collision_enabled = true
		obj.self_modulate = Color("fff")
	NodesDisabled.erase(obj)

func disable_node(obj: Node) -> void:
	if obj is TileMapLayer:
		obj.collision_enabled = false
		obj.self_modulate = Color("404040")
	NodesDisabled.append(obj)

func disable_nodes_in_list() -> void:
	for n in NodesDisabledOnStart:
		if n == null:
			continue
		disable_node(n)
