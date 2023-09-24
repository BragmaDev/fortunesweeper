extends Node2D


const HOLE_CIRCLE_EFFECT_SCENE : PackedScene = preload("res://effects/HoleCircleEffect.tscn")


func create_hole_circle_effect(pos : Vector2) -> void:
	var effect = HOLE_CIRCLE_EFFECT_SCENE.instance()
	get_tree().get_current_scene().add_child(effect)
	effect.set_global_position(pos)
