extends Node2D


onready var footstep_timer : Timer = $FootstepTimer
onready var anim : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	footstep_timer.connect("timeout", AudioManager, "play", ["flag"])
	anim.connect("animation_finished", self, "end_scene")
	anim.play("intro")
	
	EventBus.emit_signal("transition_in_triggered")


func _process(_delta : float) -> void:
	# Check for animation skip
	if Input.is_action_just_pressed("skip") and anim.current_animation_position >= 1.0:
		anim.stop()
		SceneManager.change_scene(SceneManager.MAIN_MENU_SCENE_PATH)


func end_scene(_name) -> void:
	SceneManager.change_scene(SceneManager.MAIN_MENU_SCENE_PATH)
