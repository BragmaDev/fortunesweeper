extends Control


var _game_state : GameStateData = preload("res://common/game_state_data.tres")

onready var level_result : Label = $CenterContainer/VBoxContainer/GridContainer/LevelResult
onready var time_result : Label = $CenterContainer/VBoxContainer/GridContainer/TimeResult
onready var restart_button : Button = $CenterContainer/VBoxContainer/RestartButton
onready var quit_button : Button = $CenterContainer/VBoxContainer/QuitButton
onready var anim : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	for button in [restart_button, quit_button]:
		button.connect("pressed", self, "_disable_buttons")
	
	restart_button.connect("pressed", SceneManager, "change_scene", [SceneManager.MAIN_SCENE_PATH])
	quit_button.connect("pressed", SceneManager, "change_scene", [SceneManager.MAIN_MENU_SCENE_PATH])
	
	level_result.set_text("Level " + str(_game_state.level))
	time_result.set_text(Formatter.format_time_string(_game_state.time))
	
	anim.play("show")
	
	EventBus.emit_signal("transition_in_triggered")


func _process(_delta : float) -> void:
	# Check for animation skip
	if Input.is_action_just_pressed("skip") and anim.current_animation_position >= 0.5:
		anim.seek(8.0)


func _disable_buttons() -> void:
	for button in [restart_button, quit_button]:
		button.set_disabled(true)
