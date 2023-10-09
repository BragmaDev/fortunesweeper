extends AnimatedSprite


onready var anim : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	EventBus.connect("money_decreased", self, "start_animation", ["shocked"])
	EventBus.connect("money_increased", self, "start_animation", ["happy"])
	EventBus.connect("revealed_gold", self, "start_animation", ["shocked"])
	EventBus.connect("revealed_diamond", self, "start_animation", ["shocked"])


func start_animation(animation_name : String) -> void:
	anim.stop()
	anim.play(animation_name)
