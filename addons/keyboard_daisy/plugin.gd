tool
extends EditorPlugin

var dw = preload("res://addons/keyboard_daisy/daisywheel.gd")

func _enter_tree():
	add_custom_type("Daisywheel", "Node2D", dw, get_editor_interface().get_base_control().get_icon("TextEdit", "EditorIcons"))

func _exit_tree():
	remove_custom_type("Daisywheel")

func handles_obj(obj) -> bool: return obj is dw
