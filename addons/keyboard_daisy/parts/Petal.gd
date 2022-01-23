tool
class_name Petal
extends Sprite
signal pressed(key)

var tween:Tween
var button_set:PetalButtonSet
export(Array, String) var button_characters := [] setget set_button_characters
export(float) var button_rotation:float = 0.0 setget set_button_rotation

func _ready():
	tween = Tween.new()
	add_child(tween)
	button_set = preload("res://addons/keyboard_daisy/parts/PetalButtonSet.gd").new()
	button_set.button_rotation = button_rotation
	button_set.button_vals = button_characters
	button_set.connect("pressed", self, "_on_set_pressed")
	add_child(button_set)

func _on_set_pressed(key:String): emit_signal("pressed", key)
func set_button_rotation(f:float):
	button_rotation = f
	if button_set != null: button_set.button_rotation = f
func set_button_characters(a:Array):
	button_characters = a
	if button_set != null: button_set.button_vals = a

func activate():
	if tween == null: return
	tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(1.25, 1.25), 0.25)
	tween.interpolate_property(self, "z_index", 0, 10, 0.25)
	tween.interpolate_property(button_set, "active", false, true, 0.25)
	tween.start()
func deactivate():
	if tween == null: return
	tween.interpolate_property(self, "scale", Vector2(1.25, 1.25), Vector2(1, 1), 0.25)
	tween.interpolate_property(self, "z_index", 10, 0, 0.25)
	tween.interpolate_property(button_set, "active", true, false, 0.25)
	tween.start()
