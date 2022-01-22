tool
class_name DaisyWheel
extends Node

export (String) var main_set := "abcdefghijklmnopqrstuvwxyz?!.,-_"
export (String) var capital_set := "ABCDEFGHIJKLMNOPQRSTUVWXYZ;\\&@#+"
export (String) var numeric_set := "0123456789*'=\":%(){}[]<>~`"

const QTR_PI := PI / 4.0
var petal_node:PackedScene = preload("res://addons/keyboard_daisy/parts/Petal.tscn")
enum { MAIN_MODE, CAPITAL_MODE, NUMERIC_MODE }
var mode := MAIN_MODE
var petals := []

func _ready():
	for i in range(8):
		var p:Petal = petal_node.instance()
		var my_angle := QTR_PI * i
		p.position = Vector2(0, -320).rotated(my_angle)
		p.rotation = my_angle
		p.button_rotation = -my_angle
		petals.append(p)
		add_child(p)
	set_characters()

func set_characters():
	var arr := ""
	match mode:
		MAIN_MODE: arr = main_set
		CAPITAL_MODE: arr = capital_set
		NUMERIC_MODE: arr = numeric_set
	for i in range(8):
		petals[i].button_characters = [arr[i*4+0], arr[i*4+1], arr[i*4+2], arr[i*4+3]]
