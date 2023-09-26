class_name TransitionRect
extends TextureRect


func _ready() -> void:
	EventBus.connect("transition_in_triggered", self, "start_transition_in")
	EventBus.connect("transition_out_triggered", self, "start_transition_out")
	start_transition_in()


func start_transition_in(duration : float = 0.7) -> void:
	show()
	material.set("shader_param/cutoff", 1.0)
	material.set("shader_param/flipped", 0.0)
	
	var tween = create_tween()
	tween.tween_property(material, "shader_param/cutoff", 0.0, duration)


func start_transition_out(duration : float = 0.7) -> void:
	show()
	material.set("shader_param/cutoff", 0.0)
	material.set("shader_param/flipped", 1.0)
	
	var tween = create_tween()
	tween.tween_property(material, "shader_param/cutoff", 1.0, duration)
