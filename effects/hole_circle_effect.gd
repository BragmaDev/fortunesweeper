extends Node2D


var _radius : float = 0.0


func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "_radius", 180.0, 2.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.connect("finished", self, "queue_free")


func _process(_delta : float) -> void:
	update()


func _draw() -> void:
	draw_circle(Vector2.ZERO, _radius, Colors.BLACK)
