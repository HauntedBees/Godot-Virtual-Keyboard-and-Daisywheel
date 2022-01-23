extends Node2D
func _ready():
	$VirtualKeyboard.connect("new_value", self, "_on_VirtualKeyboard_new_value")
	$VirtualKeyboard.connect("confirm", self, "_on_VirtualKeyboard_confirm")
func _on_VirtualKeyboard_new_value(s:String): $TextEdit.text = s
func _on_VirtualKeyboard_confirm(s:String): $Label.text = "Hello %s :)" % s
