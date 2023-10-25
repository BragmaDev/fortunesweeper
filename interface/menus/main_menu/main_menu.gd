extends Node2D


onready var canvas : CanvasLayer = $CanvasLayer
onready var start_button : Button = $CanvasLayer/CenterContainer/VBoxContainer/StartButton
onready var help_button : Button = $CanvasLayer/CenterContainer/VBoxContainer/HelpButton
onready var credits_button : Button = $CanvasLayer/CenterContainer/VBoxContainer/CreditsButton
onready var quit_button : Button = $CanvasLayer/CenterContainer/VBoxContainer/QuitButton
onready var sound_vol_slider : HSlider = $CanvasLayer/SoundVolumeSlider
onready var music_vol_slider : HSlider = $CanvasLayer/MusicVolumeSlider
onready var pb_label : Label = $CanvasLayer/PBLabel
onready var credits : Control = $CreditsCanvas/Credits


func _ready() -> void:
	for button in [start_button, help_button, credits_button, quit_button]:
		button.connect("pressed", self, "_disable_buttons")
	
	start_button.connect("pressed", SceneManager, "change_scene", [SceneManager.MAIN_SCENE_PATH])
	help_button.connect("pressed", SceneManager, "change_scene", [SceneManager.HELP_SCENE_PATH])
	credits_button.connect("pressed", self, "_show_credits")
	quit_button.connect("pressed", SceneManager, "quit_game")
	sound_vol_slider.connect("value_changed", self, "_update_sound_volume")
	sound_vol_slider.connect("drag_ended", self, "_play_slider_sound")
	music_vol_slider.connect("value_changed", self, "_update_music_volume")
	credits.connect("closed", self, "_show_menu")
	
	# Disable quit button in HTML5 mode
	if OS.get_name() == "HTML5":
		quit_button.set_disabled(true)
	
	sound_vol_slider.set_value(Options.sound_volume)
	music_vol_slider.set_value(Options.music_volume)

	pb_label.set_text(Formatter.format_time_string(SaveData.best_time))
	
	credits.hide()
	
	EventBus.emit_signal("transition_in_triggered")
	AudioManager.play_music()


func _disable_buttons() -> void:
	for button in [start_button, help_button, credits_button, quit_button]:
		button.set_disabled(true)


func _show_credits() -> void:
	canvas.hide()
	credits.show()


func _play_slider_sound(_value : float) -> void:
	AudioManager.play("hover", 1.0, false)


func _show_menu() -> void:
	canvas.show()
	for button in [start_button, help_button, credits_button, quit_button]:
		button.set_disabled(false)
	
	# Disable quit button in HTML5 mode
	if OS.get_name() == "HTML5":
		quit_button.set_disabled(true)


func _update_music_volume(value : float) -> void:
	Options.set_music_volume(value)
	Options.save_config()


func _update_sound_volume(value : float) -> void:
	Options.set_sound_volume(value)
	Options.save_config()
