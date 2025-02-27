extends Node2D

class_name Card

signal hovered
signal hovered_off

var position_in_hand #used for the card animation logic
var value		     # for this deck 1-12, will be more complex for full deck with suits


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_card_signals(self)


func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered",self)
	

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off",self)
	
