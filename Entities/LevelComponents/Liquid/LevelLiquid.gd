@tool
extends Area2D
class_name LevelLiquid

var is_editor = false
enum LiquidType { POSION, WATER }
const LiquidColours = {
	LiquidType.POSION: Color("65994eaa"),
	LiquidType.WATER: Color("4e8f99aa")
}

@export var Type := LiquidType.POSION: 
	set(v): Type = v; set_liquid(v);
	get: return Type

func _ready() -> void:
	is_editor = Engine.is_editor_hint()
	$CollisionPolygon2D.polygon = $Polygon2D.polygon

func set_liquid(liquid: LiquidType) -> void:
	$Polygon2D.color = LiquidColours[liquid]

func _on_body_entered(body: Node2D) -> void:
	if body is Frog:
		if body.Type != Type:
			get_tree().reload_current_scene()
