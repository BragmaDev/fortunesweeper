extends Control


var _disabled : bool = false

onready var resume_button : Button = $CenterContainer/VBoxContainer/ResumeButton
onready var restart_button : Button = $CenterContainer/VBoxContainer/RestartButton
onready var quit_button : Button = $CenterContainer/VBoxContainer/QuitButton


func _ready() -> void:
	for button in [restart_button, quit_button]:
		button.connect("pressed", self, "_disable", [true])
	
	resume_button.connect("pressed", self, "toggle", [false])
	restart_button.connect("pressed", SceneManager, "change_scene", [SceneManager.MAIN_SCENE_PATH])
	quit_button.connect("pressed", SceneManager, "change_scene", [SceneManager.MAIN_MENU_SCENE_PATH])
	
	EventBus.connect("sequence_started", self, "_disable", [true])
	EventBus.connect("sequence_finished", self, "_disable", [false])
	
	_disabled = false


func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("pause") and not _disabled:
		toggle(not is_visible())


func toggle(active : bool) -> void:
	if _disabled:
		return
	
	set_visible(active)
	SceneManager.set_pause(active)


func _disable(value : bool) -> void:
	_disabled = value
	for button in [resume_button, restart_button, quit_button]:
		button.set_disabled(value)
