tool
class_name PetalButtonSet
extends Node2D

signal pressed(key)
var petal_button := preload("res://addons/keyboard_daisy/parts/PetalButton.tscn")
export(float) var button_rotation := 0.0 setget set_button_rotation
export(Array, String) var button_vals := [] setget set_button_val
export (bool) var active := false setget set_active
var buttons := []

func _ready():
	buttons = [
		_get_default_button(Color(0, 1, 0), Vector2(0, 72)),
		_get_default_button(Color(1, 0, 0), Vector2(72, 0)),
		_get_default_button(Color(0, 0, 1), Vector2(-72, 0)),
		_get_default_button(Color(1, 1, 0), Vector2(0, -72))
	]
	set_button_rotation(button_rotation)
	set_button_val(button_vals)

func _input(event:InputEvent):
	if !active || !(event is InputEventJoypadButton): return
	var idx := (event as InputEventJoypadButton).button_index
	if idx < 0 || idx >= buttons.size(): return
	buttons[idx].pressed = event.pressed
	if !event.pressed: return
	var val:String = ""
	match idx:
		0: val = button_vals[3]
		1: val = button_vals[2]
		2: val = button_vals[0]
		3: val = button_vals[1]
	if val != "": emit_signal("pressed", val)

func set_button_val(a:Array):
	button_vals = a
	if buttons.size() == 0 || button_vals.size() == 0: return
	while button_vals.size() < 4: button_vals.append("")
	buttons[0].text = button_vals[3]
	buttons[1].text = button_vals[2]
	buttons[2].text = button_vals[0]
	buttons[3].text = button_vals[1]
	set_active(active)
func set_button_rotation(br:float):
	button_rotation = br
	if is_inside_tree(): rotation = br
func set_active(b:bool):
	active = b
	if buttons.size() > 0:
		for bt in buttons:
			bt.button_active = b
			if !active: bt.pressed = false

func _get_default_button(c:Color, pos:Vector2) -> PetalButton:
	var pb:PetalButton = petal_button.instance()
	pb.button_active = Engine.editor_hint
	pb.button_color = c
	pb.position = pos
	add_child(pb)
	return pb
