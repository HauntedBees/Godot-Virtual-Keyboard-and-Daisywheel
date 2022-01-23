tool
class_name VirtualKeyboard
extends MarginContainer

export(Array,String) var sections := [
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ",
	"abcdefghijklmnopqrstuvwxyz",
	"1234567890?!-~.,/*"
]
export(int) var columns_per_section := 5
export(int) var sections_to_show := 0
export(int) var min_rows := 6
export(bool) var fill_in_last_row := true
export(Vector2) var min_key_size := Vector2(30, 30)
export(Array,String) var special_options := ["Space", "Delete", "OK"]

var cursor_position := Vector2(0, 0)
var main_section:Container

func _ready():
	size_flags_horizontal = Container.SIZE_EXPAND_FILL
	size_flags_vertical = Container.SIZE_EXPAND_FILL
	reset_sections()

func reset_sections():
	for i in get_children(): remove_child(i)
	var num_sections := sections.size()
	if num_sections == 0: return
	if num_sections == 1:
		main_section = get_section(sections[0])
		add_child(main_section)
	else:
		main_section = _get_hbox()
		add_child(main_section)
		for i in sections.size():
			if i > 0: main_section.add_child(VSeparator.new())
			main_section.add_child(get_section(sections[i]))

func get_section(keys:String) -> VBoxContainer:
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
	return container

func _get_hbox() -> HBoxContainer:
	var hb := HBoxContainer.new()
	hb.size_flags_horizontal = Container.SIZE_EXPAND_FILL
	hb.size_flags_vertical = Container.SIZE_EXPAND_FILL
	return hb

func _get_button(t:String = "") -> Button:
	var b := Button.new()
	b.text = t
	if t == "": b.disabled = true
	b.align = Button.ALIGN_CENTER
	b.rect_size = min_key_size
	b.rect_min_size = min_key_size
	b.size_flags_horizontal = Container.SIZE_EXPAND_FILL
	b.size_flags_vertical = Container.SIZE_EXPAND_FILL
	return b
