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
var bars_b = []
var values_b = []
var bars_c = []
var temp_color
var selected_prop : NUMBER_PROPERTY = NUMBER_PROPERTY.EVEN
var current_idx : int = 0
var b_idx : int = 0
var c_idx : int = 0
var stopped : bool = false

var pseudocode_lines = [
	"function SplitSelection(N, A, q, B, r, C)",
	"\tq = 0, r = 0",
	"",
	"\tloop i=1 to N",
	"\t\tif T(A(i)) then",
	"\t\t\tq = q + 1",
	"\t\t\tB(q) = A(i)",
	"\t\telse",
	"\t\t\tr = r + 1",
	"\t\t\tC(r) = A(i)",
	"\t\tend of if",
	"\tend of loop",
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


func _on_index_changed(idx):
	_update_info_label()


func _update_info_label():
	$InfoLabel.clear()
	$InfoLabel.append_text("[b][color=orange]PARAMETERS[/color][/b]")
	$InfoLabel.newline()
	$InfoLabel.append_text("i = %d\t\tq = %d\t\tr = %d" % [current_idx + 1, b_idx, c_idx])
	$InfoLabel.newline()
	$InfoLabel.append_text("Selected property: %s" % NUMBER_PROPERTY_STRINGS[selected_prop])


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
	if temp_color and current_idx <= values.size() - 1:
		bars[current_idx].color = temp_color
	elif temp_color and current_idx == values.size():
		bars[current_idx - 1].color = temp_color
	current_idx = 0
	temp_color = null
	
	if bars_b:
		for bar in bars_b:
			remove_child(bar)
		bars_b = []
	
	b_idx = 0
	
	stopped = false

	_update_info_label()
	_reset_pseudocode()

func _generate_values():
	values = []
	values_b = []
	
	if bars:
		for bar in bars:
			remove_child(bar)
		bars = []
	
	for i in range(10):
		var value = randi_range(10, 100)
		values.append(value)
		
		var bar = ColorRect.new()
		bar.size = Vector2(32, 32)
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


func _duplicate_bar(old_bar, text):
	var bar = ColorRect.new()
	bar.size = old_bar.size
	bar.color = temp_color
	bar.position = old_bar.position
	
	var outline = ReferenceRect.new()
	outline.size = bar.size + Vector2(outline.border_width, outline.border_width)
	outline.editor_only = false
	outline.border_color = Color.BLACK
	
	var label = RichTextLabel.new()
	label.size = bar.size
	label.position = Vector2(label.position.x, 5)
	label.bbcode_enabled = true
	label.append_text("[center]%s[/center]" % text)
	label.fit_content = false
	
	bar.add_child(label)
	bar.add_child(outline)
	
	return bar


func _on_run_button_pressed():
	if current_idx == 0:
		_highlight_code_line(0)
		await get_tree().create_timer(0.5).timeout
		_highlight_code_line(1)
		await get_tree().create_timer(0.5).timeout

	if current_idx == values.size():
		if not stopped:
			stopped = true
			_highlight_code_line(11)
			await get_tree().create_timer(0.5).timeout
			_highlight_code_line(12)
		return
	
	if temp_color:
		bars[current_idx - 1].color = temp_color
	
	temp_color = bars[current_idx].color
	bars[current_idx].color = Color.RED
	
	_highlight_code_line(3)
	await get_tree().create_timer(0.5).timeout
	
	_highlight_code_line(4)
	await get_tree().create_timer(0.5).timeout
	
	match selected_prop:
		NUMBER_PROPERTY.EVEN:
			if values[current_idx] % 2 == 0:
				_highlight_code_line(5)
				await get_tree().create_timer(0.5).timeout
				
				var bar = _duplicate_bar(bars[current_idx], values[current_idx])
				bars_b.append(bar)
				add_child(bar)
				
				var tween2 = create_tween()
				tween2.tween_property(bar, "position", Vector2(70, 20 + (40 * b_idx)), 0.75)
				
				bars[current_idx].color = Color.LIME
				b_idx += 1
				
				_highlight_code_line(6)
				await get_tree().create_timer(0.5).timeout
			else:
				_highlight_code_line(7)
				await get_tree().create_timer(0.5).timeout
				_highlight_code_line(8)
				await get_tree().create_timer(0.5).timeout
				
				var bar = _duplicate_bar(bars[current_idx], values[current_idx])
				bars_c.append(bar)
				add_child(bar)
				
				var tween2 = create_tween()
				tween2.tween_property(bar, "position", Vector2(130, 20 + (40 * c_idx)), 0.75)
				
				c_idx += 1
				
				_highlight_code_line(9)
				await get_tree().create_timer(0.5).timeout
		NUMBER_PROPERTY.ODD:
			if values[current_idx] % 2 != 0:
				_highlight_code_line(5)
				await get_tree().create_timer(0.5).timeout
				
				var bar = _duplicate_bar(bars[current_idx], values[current_idx])
				bars_b.append(bar)
				add_child(bar)
				
				var tween2 = create_tween()
				tween2.tween_property(bar, "position", Vector2(70, 20 + (40 * b_idx)), 0.75)
				
				bars[current_idx].color = Color.LIME
				b_idx += 1
				
				_highlight_code_line(6)
				await get_tree().create_timer(0.5).timeout
			else:
				_highlight_code_line(7)
				await get_tree().create_timer(0.5).timeout
				_highlight_code_line(8)
				await get_tree().create_timer(0.5).timeout
				
				var bar = _duplicate_bar(bars[current_idx], values[current_idx])
				bars_c.append(bar)
				add_child(bar)
				
				var tween2 = create_tween()
				tween2.tween_property(bar, "position", Vector2(130, 20 + (40 * c_idx)), 0.75)
				
				c_idx += 1
				
				_highlight_code_line(9)
				await get_tree().create_timer(0.5).timeout
		NUMBER_PROPERTY.PRIME:
			if _is_prime(values[current_idx]):
				_highlight_code_line(5)
				await get_tree().create_timer(0.5).timeout
				
				var bar = _duplicate_bar(bars[current_idx], values[current_idx])
				bars_b.append(bar)
				add_child(bar)
				
				var tween2 = create_tween()
				tween2.tween_property(bar, "position", Vector2(70, 20 + (40 * b_idx)), 0.75)
				
				bars[current_idx].color = Color.LIME
				b_idx += 1
				
				_highlight_code_line(6)
				await get_tree().create_timer(0.5).timeout
			else:
				_highlight_code_line(7)
				await get_tree().create_timer(0.5).timeout
				_highlight_code_line(8)
				await get_tree().create_timer(0.5).timeout
				
				var bar = _duplicate_bar(bars[current_idx], values[current_idx])
				bars_c.append(bar)
				add_child(bar)
				
				var tween2 = create_tween()
				tween2.tween_property(bar, "position", Vector2(130, 20 + (40 * c_idx)), 0.75)
				
				c_idx += 1
				
				_highlight_code_line(9)
				await get_tree().create_timer(0.5).timeout
	
	_highlight_code_line(10)
	await get_tree().create_timer(0.5).timeout
	
	current_idx += 1
	index_changed.emit(current_idx)
