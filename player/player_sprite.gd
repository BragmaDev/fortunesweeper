extends AnimatedSprite


onready var anim : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	EventBus.connect("money_decreased", anim, "play", ["shocked"])
