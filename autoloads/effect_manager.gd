extends Node2D


const HOLE_CIRCLE_EFFECT_SCENE : PackedScene = preload("res://effects/HoleCircleEffect.tscn")
const TEXT_POPUP_SCENE : PackedScene = preload("res://effects/TextPopup.tscn")


func create_hole_circle_effect(pos : Vector2) -> void:
	var effect = HOLE_CIRCLE_EFFECT_SCENE.instance()
	get_tree().get_current_scene().add_child(effect)
	effect.set_global_position(pos)


func create_text_popup(pos : Vector2, text : String, color : Color) -> void:
	var popup = TEXT_POPUP_SCENE.instance()
	popup.init(text, color)
	get_tree().get_current_scene().add_child(popup)
	popup.set_global_position(pos)
