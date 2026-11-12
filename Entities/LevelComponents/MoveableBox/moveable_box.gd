@tool
class_name MoveableBox extends RigidBody2D

@onready var Sprite: Sprite2D = $Sprite2D
@onready var Collider: CollisionShape2D = $CollisionShape2D

@export_category("Box")
@export var boxTexture: Texture2D
@export var scaleWidth: float = 1.0
@export var scaleHeight: float = 1.0

func _ready() -> void:
	Sprite.texture = boxTexture
	Sprite.scale = Vector2(scaleWidth, scaleHeight)
	
	ResizeColliderToSprite()



func ResizeColliderToSprite() -> void:
	if (Sprite.texture):
		var _spriteSize = Sprite.get_rect().size * Sprite.scale
		
		# Checks if collider has a shape
		if (Collider.shape is RectangleShape2D):
			Collider.shape.extents = _spriteSize / 2
		elif (Collider.shape is CircleShape2D):
			Collider.shape.radius = max(_spriteSize.x, _spriteSize.y) / 2
		else:
			print("Collider shape isn't supported idiot")
	else:
		print("Put a sprite in")
