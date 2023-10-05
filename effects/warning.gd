extends AnimatedSprite


func _ready() -> void:
	play("default")
	get_tree().create_timer(1.0, false).connect("timeout", self, "queue_free")
