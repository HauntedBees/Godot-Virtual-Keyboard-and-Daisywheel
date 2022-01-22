tool
class_name Petal
extends Sprite

var button_set:PetalButtonSet
export(Array, String) var button_characters := [] setget set_button_characters
export(float) var button_rotation:float = 0.0 setget set_button_rotation

func _ready():
	button_set = preload("res://addons/keyboard_daisy/parts/PetalButtonSet.gd").new()
	button_set.button_rotation = button_rotation
	button_set.button_vals = button_characters
	add_child(button_set)

func set_button_rotation(f:float):
	button_rotation = f
	if button_set != null: button_set.button_rotation = f
func set_button_characters(a:Array):
	button_characters = a
	if button_set != null: button_set.button_vals = a
