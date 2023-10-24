extends Node2D


onready var start_button : Button = $CanvasLayer/CenterContainer/VBoxContainer/StartButton
onready var help_button : Button = $CanvasLayer/CenterContainer/VBoxContainer/HelpButton
onready var credits_button : Button = $CanvasLayer/CenterContainer/VBoxContainer/CreditsButton
onready var quit_button : Button = $CanvasLayer/CenterContainer/VBoxContainer/QuitButton
onready var sound_vol_slider : HSlider = $CanvasLayer/SoundVolumeSlider
onready var pb_label : Label = $CanvasLayer/PBLabel


func _ready() -> void:
	for button in [start_button, quit_button]:
		button.connect("pressed", self, "_disable_buttons")
	
	start_button.connect("pressed", SceneManager, "change_scene", [SceneManager.MAIN_SCENE_PATH])
	help_button.connect("pressed", SceneManager, "change_scene", [SceneManager.HELP_SCENE_PATH])
	quit_button.connect("pressed", SceneManager, "quit_game")
	sound_vol_slider.connect("value_changed", self, "_update_sound_volume")
	sound_vol_slider.connect("drag_ended", self, "_play_slider_sound")
	
	sound_vol_slider.set_value(Options.sound_volume)

	pb_label.set_text(Formatter.format_time_string(SaveData.best_time))
	
	EventBus.emit_signal("transition_in_triggered")


func _disable_buttons() -> void:
	for button in [start_button, help_button, credits_button, quit_button]:
		button.set_disabled(true)


func _play_slider_sound(_value : float) -> void:
	AudioManager.play("hover", 1.0, false)


func _update_sound_volume(value : float) -> void:
	Options.set_sound_volume(value)
	Options.save_config()
