extends Node2D


onready var start_button : Button = $CanvasLayer/CenterContainer/VBoxContainer/StartButton
onready var help_button : Button = $CanvasLayer/CenterContainer/VBoxContainer/HelpButton
onready var credits_button : Button = $CanvasLayer/CenterContainer/VBoxContainer/CreditsButton
onready var quit_button : Button = $CanvasLayer/CenterContainer/VBoxContainer/QuitButton
onready var sound_vol_slider : HSlider = $CanvasLayer/SoundVolumeSlider


func _ready() -> void:
	for button in [start_button, quit_button]:
		button.connect("pressed", self, "_disable_buttons")
	
	start_button.connect("pressed", SceneManager, "change_scene", [SceneManager.MAIN_SCENE_PATH])
	quit_button.connect("pressed", SceneManager, "quit_game")
	sound_vol_slider.connect("value_changed", Options, "set_sound_volume")
	
	EventBus.emit_signal("transition_in_triggered")


func _disable_buttons() -> void:
	for button in [start_button, help_button, credits_button, quit_button]:
		button.set_disabled(true)
