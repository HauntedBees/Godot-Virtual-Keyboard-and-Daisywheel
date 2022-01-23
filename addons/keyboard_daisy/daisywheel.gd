tool
class_name DaisyWheel
extends Node2D
signal key_press(key)
signal new_value(val)
signal backspace

export (String) var main_set := "abcdefghijklmnopqrstuvwxyz?!.,-_"
export (String) var capital_set := "ABCDEFGHIJKLMNOPQRSTUVWXYZ;\\&@#+"
export (String) var numeric_set := "0123456789*'=\":%(){}[]<>~`"
export (int) var gamepad_index := 0
export (float) var dead_zone := 0.5
export (bool) var active := true setget set_active

const QTR_PI := PI / 4.0
var petal_node:PackedScene = preload("res://addons/keyboard_daisy/parts/Petal.tscn")
var info_node:PackedScene = preload("res://addons/keyboard_daisy/parts/DaisyInfo.tscn")
enum { MAIN_MODE, CAPITAL_MODE, NUMERIC_MODE }
var mode := MAIN_MODE
var petals := []
var active_petal:Petal
var value := ""

func _ready():
	for i in range(8):
		var p:Petal = petal_node.instance()
		var my_angle := QTR_PI * i
		p.position = Vector2(0, -320).rotated(my_angle)
		p.rotation = my_angle
		p.button_rotation = -my_angle
		p.connect("pressed", self, "_on_receive_key")
		petals.append(p)
		add_child(p)
	set_characters(MAIN_MODE, true)
	var info:Node2D = info_node.instance()
	info.position = Vector2(0, 550)
	add_child(info)

func _on_receive_key(key:String):
	if !active: return
	value += key
	emit_signal("key_press", key)
	emit_signal("new_value", value)

func _input(event:InputEvent):
	if !active || !(event is InputEventJoypadButton): return
	match (event as InputEventJoypadButton).button_index:
		JOY_L: 
			if value.length() == 0 || !event.pressed: return
			emit_signal("backspace")
			value = value.substr(0, value.length() - 1)
			emit_signal("new_value", value)
		JOY_R: if event.pressed: _on_receive_key(" ")
		JOY_L2: set_characters(NUMERIC_MODE if event.pressed else MAIN_MODE)
		JOY_R2: set_characters(CAPITAL_MODE if event.pressed else MAIN_MODE)

func _process(_delta):
	var coords := Vector2(Input.get_joy_axis(gamepad_index, JOY_AXIS_0), Input.get_joy_axis(gamepad_index, JOY_AXIS_1))
	coords.x = 0.0 if (abs(coords.x) < dead_zone) else (sign(coords.x) * 1.0)
	coords.y = 0.0 if (abs(coords.y) < dead_zone) else (sign(coords.y) * 1.0)
	var new_active_petal:Petal = null
	if coords.length() > 0:
		var angle := -coords.angle_to(Vector2(0, -1))
		var angle_idx := angle / QTR_PI
		if angle_idx < 0: angle_idx = 9 + angle_idx
		if angle_idx >= 0 && angle_idx < petals.size():
			new_active_petal = petals[angle_idx]
	if active_petal == new_active_petal: return
	if active_petal != null: active_petal.deactivate()
	active_petal = new_active_petal
	if active_petal != null: active_petal.activate()

func set_characters(new_mode:int, force:bool = false):
	if mode == new_mode && !force: return
	mode = new_mode
	var arr := ""
	match mode:
		MAIN_MODE: arr = main_set
		CAPITAL_MODE: arr = capital_set
		NUMERIC_MODE: arr = numeric_set
	var arr_size := arr.length()
	for i in range(8):
		var inner_arr := []
		for j in range(4):
			var idx := i * 4 + j
			if idx < arr_size: inner_arr.append(arr[idx])
			else: inner_arr.append("")
		petals[i].button_characters = inner_arr

func set_active(a:bool):
	if active == a: return
	active = a
	visible = a
	active_petal = null
	for p in petals: (p as Petal).deactivate()
