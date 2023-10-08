extends AnimatedSprite


onready var anim : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	EventBus.connect("money_decreased", self, "start_animation", ["shocked"])
	EventBus.connect("money_increased", self, "start_animation", ["happy"])


func start_animation(animation_name : String) -> void:
	anim.stop()
	anim.play(animation_name)
