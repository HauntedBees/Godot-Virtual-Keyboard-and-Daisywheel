tool
class_name PetalButton
extends Node2D

onready var button_icon := $Button
onready var button_text := $Label

export(Color) var pressed_color := Color.aquamarine
export(String) var text := "" setget set_text
export(bool) var button_active := false setget set_active
export(Color) var button_color := Color.rebeccapurple setget set_color
export(bool) var pressed := false setget set_pressed

func _ready():
	set_text(text)
	set_active(button_active)
	set_color(button_color)
	set_pressed(pressed)

func set_text(t:String):
	text = t
	if button_text != null: button_text.text = t
func set_active(b:bool):
	button_active = b
	if button_icon != null: button_icon.visible = b
func set_color(c:Color):
	button_color = c
	if button_icon != null: button_icon.modulate = c
func set_pressed(b:bool):
	pressed = b
	if button_icon == null || !button_active: return
	button_icon.modulate = pressed_color if pressed else button_color
