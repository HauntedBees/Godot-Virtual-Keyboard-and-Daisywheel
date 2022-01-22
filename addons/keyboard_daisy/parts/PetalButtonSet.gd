tool
class_name PetalButtonSet
extends Node2D

var petal_button := preload("res://addons/keyboard_daisy/parts/PetalButton.tscn")

export(float) var button_rotation := 0.0 setget set_button_rotation
export(Array, String) var button_vals := [] setget set_button_val
var buttons := []

func _ready():
	buttons = [
		_get_default_button(Color(0, 0, 1), Vector2(-72, 0)),
		_get_default_button(Color(1, 1, 0), Vector2(0, -72)),
		_get_default_button(Color(1, 0, 0), Vector2(72, 0)),
		_get_default_button(Color(0, 1, 0), Vector2(0, 72))
	]
	set_button_rotation(button_rotation)
	set_button_val(button_vals)

func set_button_val(a:Array):
	button_vals = a
	if buttons.size() == 0: return
	for i in button_vals.size():
		(buttons[i] as PetalButton).text = button_vals[i]
func set_button_rotation(br:float):
	button_rotation = br
	if is_inside_tree(): rotation = br

func _get_default_button(c:Color, pos:Vector2) -> PetalButton:
	var pb:PetalButton = petal_button.instance()
	pb.button_active = Engine.editor_hint
	pb.button_color = c
	pb.position = pos
	add_child(pb)
	return pb
