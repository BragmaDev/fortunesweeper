class_name TextPopup
extends Node2D


func _ready() -> void:
	var tween = create_tween()
	tween.connect("finished", self, "queue_free")
	tween.tween_property($Label, "rect_position", $Label.rect_position + Vector2(0, -16), 1.0)


func init(text : String, color : Color) -> void:
	$Label.set_text(text)
	$Label.set("custom_colors/font_color", color)
