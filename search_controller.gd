extends Control

signal index_changed(new)
signal number_found(num, index)

enum NUMBER_PROPERTY {
	EVEN,
	ODD,
	PRIME,
}

const NUMBER_PROPERTY_STRINGS = [
	"Even numbers",
	"Odd numbers",
	"Prime numbers"
]

var values = []
var bars = []
var temp_color
var selected_prop : NUMBER_PROPERTY = NUMBER_PROPERTY.EVEN
var current_idx : int = 0
var num_found : bool = false

var pseudocode_lines = [
	"function Search(N, A, exists, s)",
	"\ti = 1",
	"",
	"\tloop (i <= N) and (not(T(A(i))))",
	"\t\ti = i + 1",
	"\tend of loop",
	"",
	"\tif i <= N then",
	"\t\texists = true",
	"\telse",
	"\t\texists = false",
	"\tend of if",
	"",
	"\tif exists then",
	"\t\ts = i",
	"\tend of if",
	"end of function"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$ReturnButton.pressed.connect(self._return_to_menu)
	$OptionsButton.get_popup().hide_on_checkable_item_selection = false
	$OptionsButton.get_popup().set_item_checked(int(selected_prop) + 3, true)
	$OptionsButton.get_popup().id_pressed.connect(self._on_options_button_pressed)
	$RunButton.pressed.connect(self._on_run_button_pressed)
	
	_generate_values()
	
	_update_info_label()
	
	number_found.connect(self._on_number_found)
	index_changed.connect(self._on_index_changed)


func _highlight_code_line(lineno):
	$PseudocodeLabel.clear()
	for i in range(pseudocode_lines.size()):
		var line = pseudocode_lines[i]
		if lineno == i:
			$PseudocodeLabel.append_text("[color=red]%s[/color]" % line)
		else:
			$PseudocodeLabel.append_text(line)
		if lineno < pseudocode_lines.size():
			$PseudocodeLabel.newline()


func _reset_pseudocode():
	$PseudocodeLabel.clear()
	for line in pseudocode_lines:
		$PseudocodeLabel.append_text(line)
		if line != "end of function":
			$PseudocodeLabel.newline()


func _on_number_found(num, idx):
	_update_info_label()
	_append_info_label(num, idx)
	_highlight_code_line(13)
	await get_tree().create_timer(0.5).timeout
	_highlight_code_line(14)
	await get_tree().create_timer(0.5).timeout
	_highlight_code_line(15)
	await get_tree().create_timer(0.5).timeout
	_highlight_code_line(16)


func _on_index_changed(idx):
	pass


func _update_info_label():
	$InfoLabel.clear()
	$InfoLabel.append_text("[b][color=orange]PARAMETERS[/color][/b]")
	$InfoLabel.newline()
	$InfoLabel.append_text("i = %d\t\texists = %s\t\ts = %d" % [current_idx + 1, num_found, (current_idx if num_found else 0)])
	$InfoLabel.newline()
	$InfoLabel.append_text("Selected property: %s" % NUMBER_PROPERTY_STRINGS[selected_prop])


func _append_info_label(num, idx):
	$InfoLabel.newline()	
	$InfoLabel.append_text("Found number: %d, index: %d" % [num, idx])



func _on_options_button_pressed(id):
	match id:
		0:
			_reset()
			_generate_values()
		1:
			_reset()
		3:
			$OptionsButton.get_popup().set_item_checked(id, true)
			$OptionsButton.get_popup().set_item_checked(4, false)
			$OptionsButton.get_popup().set_item_checked(5, false)
			selected_prop = NUMBER_PROPERTY.EVEN
			_reset()
		4:
			$OptionsButton.get_popup().set_item_checked(id, true)
			$OptionsButton.get_popup().set_item_checked(3, false)
			$OptionsButton.get_popup().set_item_checked(5, false)
			selected_prop = NUMBER_PROPERTY.ODD
			_reset()
		5:
			$OptionsButton.get_popup().set_item_checked(id, true)
			$OptionsButton.get_popup().set_item_checked(3, false)
			$OptionsButton.get_popup().set_item_checked(4, false)
			selected_prop = NUMBER_PROPERTY.PRIME
			_reset()


func _get_random_color():
	var color = Color(randf(), randf(), randf())
	
	if abs(color.h - Color.RED.h) <= 0.25 or abs(color.h - Color.LIME.h) <= 0.25:
		color = _get_random_color()

	return color


func _reset():
	if temp_color:
		bars[current_idx].color = temp_color
	current_idx = 0
	temp_color = null
	num_found = false

	_update_info_label()
	_reset_pseudocode()

func _generate_values():
	values = []
	
	if bars:
		for bar in bars:
			remove_child(bar)
		bars = []
	
	for i in range(10):
		var value = randi_range(10, 100)
		values.append(value)
		
		var bar = ColorRect.new()
		bar.size = Vector2(20 * (float(value) / 10.0), 32)
		bar.position = Vector2(10, 20 + (40 * i))
		bar.color = _get_random_color()
		
		var outline = ReferenceRect.new()
		outline.size = bar.size + Vector2(outline.border_width, outline.border_width)
		outline.editor_only = false
		outline.border_color = Color.BLACK
		
		var label = RichTextLabel.new()
		label.size = bar.size
		label.position = Vector2(label.position.x, 5)
		label.bbcode_enabled = true
		label.append_text("[center]%d[/center]" % value)
		label.fit_content = false
		
		bar.add_child(label)
		bar.add_child(outline)
		
		bars.append(bar)
		add_child(bar)


func _return_to_menu():
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _is_prime(num: int) -> bool:
	for i in range(2, int(sqrt(num)) + 1):
		if num % i == 0:
			return false
	return true


func _on_run_button_pressed():
	if current_idx == 0:
		_highlight_code_line(0)
		await get_tree().create_timer(0.5).timeout
		_highlight_code_line(1)
		await get_tree().create_timer(0.5).timeout

	if num_found:
		return
	
	_highlight_code_line(3)
	await get_tree().create_timer(0.5).timeout
	_highlight_code_line(4)
	await get_tree().create_timer(0.5).timeout
	
	if temp_color:
		bars[current_idx - 1].color = temp_color
	
	temp_color = bars[current_idx].color
	bars[current_idx].color = Color.RED
	
	_update_info_label()
	
	var found = false
	
	match selected_prop:
		NUMBER_PROPERTY.EVEN:
			if values[current_idx] % 2 == 0:
				found = true
		NUMBER_PROPERTY.ODD:
			if values[current_idx] % 2 != 0:
				found = true
		NUMBER_PROPERTY.PRIME:
			if _is_prime(values[current_idx]):
				found = true
	
	_highlight_code_line(7)
	await get_tree().create_timer(0.5).timeout
	
	if found:
		_highlight_code_line(8)
		await get_tree().create_timer(0.5).timeout
		num_found = true
		bars[current_idx].color = Color.LIME
		number_found.emit(values[current_idx], current_idx)
		return
	
	_highlight_code_line(9)
	await get_tree().create_timer(0.5).timeout
	_highlight_code_line(10)
	await get_tree().create_timer(0.5).timeout
	_highlight_code_line(11)
	
	if current_idx == values.size() - 1:
		current_idx = 0
		index_changed.emit(current_idx)
		return
	
	current_idx += 1
	index_changed.emit(current_idx)
