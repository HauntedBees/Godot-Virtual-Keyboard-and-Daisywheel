tool
class_name VirtualKeyboard
extends MarginContainer
signal key_pressed(s)
signal new_value(s)
signal backspace
signal confirm

export(Array,String) var sections := [
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ",
	"abcdefghijklmnopqrstuvwxyz",
	"1234567890?!-~.,/*"
]
export(int) var columns_per_section := 5 setget set_columns_per_section
export(int) var split_into_sections := 0 setget set_split_into_sections # unused
export(int) var min_rows := 6 setget set_min_rows
export(bool) var fill_in_last_row := true setget set_fill_in_last_row
export(Vector2) var min_key_size := Vector2(30, 30) setget set_min_key_size
export(Array, int, "Confirm", "Space", "Delete", "Switch") var special_options := [0, 1, 2] setget set_special_options
export(bool) var separate_special_options := false setget set_separate_special_options
export(String) var confirm_name := "OK" setget set_confirm_name
export(String) var space_name := "SPACE" setget set_space_name
export(String) var delete_name := "BACK" setget set_delete_name
export(String) var switch_name_to := "ABC" setget set_switch_name_to # unused
export(String) var switch_name_from := "abc" setget set_switch_name_from

var value := ""
var section_toggled := false
var cursor_position := Vector2(0, 0)
var main_section:Container

func _ready():
	size_flags_horizontal = Container.SIZE_EXPAND_FILL
	size_flags_vertical = Container.SIZE_EXPAND_FILL
	reset_sections()

func set_columns_per_section(c:int):
	columns_per_section = c
	reset_sections()
func set_split_into_sections(i:int):
	split_into_sections = i
	reset_sections()
func set_min_rows(i:int):
	min_rows = i
	reset_sections()
func set_fill_in_last_row(b:bool):
	fill_in_last_row = b
	reset_sections()
func set_min_key_size(v:Vector2):
	min_key_size = v
	reset_sections()
func set_special_options(a:Array):
	special_options = a
	reset_sections()
func set_separate_special_options(b:bool):
	separate_special_options = b
	reset_sections()
func set_confirm_name(s:String):
	confirm_name = s
	reset_sections()
func set_space_name(s:String):
	space_name = s
	reset_sections()
func set_delete_name(s:String):
	delete_name = s
	reset_sections()
func set_switch_name_to(s:String):
	switch_name_to = s
	reset_sections()
func set_switch_name_from(s:String):
	switch_name_from = s
	reset_sections()

func reset_sections():
	if !is_inside_tree(): return
	for i in get_children(): remove_child(i)
	var num_sections := sections.size()
	if num_sections == 0: return
	if num_sections == 1:
		main_section = get_section(sections[0], true)
		add_child(main_section)
	else:
		main_section = _get_hbox()
		add_child(main_section)
		var last_section := sections.size() - 1
		for i in sections.size():
			if i > 0: main_section.add_child(VSeparator.new())
			main_section.add_child(get_section(sections[i], i == last_section))

func get_section(keys:String, last_section:bool) -> VBoxContainer:
	var container := VBoxContainer.new()
	container.size_flags_horizontal = Container.SIZE_EXPAND_FILL
	container.size_flags_vertical = Container.SIZE_EXPAND_FILL
	container.rect_min_size = Vector2(100, 100)
	if keys == "": return container
	var num_rows := 0
	var current_row:HBoxContainer = null
	for i in keys.length():
		if i % columns_per_section == 0:
			if current_row != null: container.add_child(current_row)
			current_row = _get_hbox()
			num_rows += 1
		current_row.add_child(_get_button(keys[i]))
	if fill_in_last_row && (keys.length() % columns_per_section) != 0:
		var remaining_keys:int = columns_per_section - (keys.length() % columns_per_section)
		for i in remaining_keys:
			current_row.add_child(_get_button())
	container.add_child(current_row)
	if num_rows < min_rows:
		for i in range(min_rows - num_rows):
			current_row = _get_hbox()
			for j in columns_per_section:
				current_row.add_child(_get_button())
			container.add_child(current_row)
	if last_section && special_options.size() > 0:
		var last_row_count := current_row.get_child_count()
		var special_start := last_row_count - special_options.size()
		var last_relevant_button:Button = current_row.get_child(special_start)
		if separate_special_options || !last_relevant_button.disabled: # need to make a new row 
			current_row = _get_hbox()
			for i in columns_per_section:
				if i >= special_start:
					current_row.add_child(_get_special_button(special_options[i - special_start]))
				else: current_row.add_child(_get_button())
			container.add_child(current_row)
		else: # can add to existing row
			current_row.remove_child(current_row.get_child(special_start))
			current_row.remove_child(current_row.get_child(special_start - 1))
			current_row.remove_child(current_row.get_child(special_start - 2))
			for s in special_options:
				current_row.add_child(_get_special_button(s))
	return container

func _get_hbox() -> HBoxContainer:
	var hb := HBoxContainer.new()
	hb.size_flags_horizontal = Container.SIZE_EXPAND_FILL
	hb.size_flags_vertical = Container.SIZE_EXPAND_FILL
	return hb

func _get_special_button(type:int) -> Button:
	var custom_text := ""
	match type:
		0: custom_text = confirm_name
		1: custom_text = space_name
		2: custom_text = delete_name
		3: custom_text = switch_name_from if section_toggled else switch_name_to
	return _get_button(custom_text)

func _get_button(t:String = "") -> Button:
	var b := Button.new()
	b.text = t
	if t == "": b.disabled = true
	b.align = Button.ALIGN_CENTER
	b.rect_size = min_key_size
	b.rect_min_size = min_key_size
	b.size_flags_horizontal = Container.SIZE_EXPAND_FILL
	b.size_flags_vertical = Container.SIZE_EXPAND_FILL
	b.connect("pressed", self, "_on_key_press", [b])
	return b

func _on_key_press(b:Button):
	match b.text:
		confirm_name:
			emit_signal("confirm")
		space_name:
			value += " "
			emit_signal("key_pressed", b.text)
			emit_signal("new_value", value)
		delete_name:
			value = value.substr(0, value.length() - 1)
			emit_signal("backspace")
			emit_signal("new_value", value)
		switch_name_from:
			print("THIS")
		switch_name_to:
			print("THAT")
		_:
			value += b.text
			emit_signal("key_pressed", b.text)
			emit_signal("new_value", value)
