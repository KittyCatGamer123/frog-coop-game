@tool
class_name MovingPlatform extends Path2D

@onready var Path: PathFollow2D = $PathFollow2D
@onready var Transform: RemoteTransform2D = $PathFollow2D/RemoteTransform2D
@onready var Body: AnimatableBody2D = $AnimatableBody2D
@onready var Sprite: Sprite2D = $AnimatableBody2D/Platform
@onready var Collider: CollisionShape2D = $AnimatableBody2D/CollisionShape2D

@export_category("Platform")
@export var platformTexture: Texture2D
@export var scaleWidth: float = 1.0
@export var scaleHeight: float = 1.0

@export_category("Platform Movement")
@export var speed = 25
var pathProgress = 0



func _ready() -> void:
	Sprite.texture = platformTexture
	Sprite.scale = Vector2(scaleWidth, scaleHeight)
	Path.progress = 0
	pathProgress = 0
	
	ResizeColliderToSprite()



func _physics_process(delta: float) -> void:
	if (!Engine.is_editor_hint()):
		pathProgress += (speed * delta)
		Path.set_progress(pathProgress)



func ResizeColliderToSprite():
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
