class_name BoardAnimator
extends Node


signal animation_finished

var _started : bool = false
var _tweens : Array = []


func _physics_process(_delta : float) -> void:
	if _started:
		if _tweens.empty():
			emit_signal("animation_finished")
			_started = false
			EventBus.emit_signal("sequence_finished")


func start_appear_animation(cells : Array) -> void:
	_started = true
	EventBus.emit_signal("sequence_started")
	
	for i in range(cells.size() - 1, -1, -1):
		for cell in cells[i]:
			# Move cells up	
			cell.set_position(cell.get_position() - Vector2(0, 150))
	
	for i in range(cells.size() - 1, -1, -1):
		for cell in cells[i]:
			var final_pos = cell.get_position() + Vector2(0, 150)
			var tween = create_tween()
			_tweens.append(tween)
			
			tween.set_trans(Tween.TRANS_QUART)
			tween.tween_property(cell, "position", final_pos, 0.6)
			tween.connect("finished", self, "_erase_from_tweens", [tween])
			
			# Create delay
			yield(get_tree().create_timer(0.008, false), "timeout")


func _erase_from_tweens(tween : SceneTreeTween) -> void:
	_tweens.erase(tween)
