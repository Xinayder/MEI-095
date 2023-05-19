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
var values_c = []
var temp_color
var temp_color2
var selected_prop : NUMBER_PROPERTY = NUMBER_PROPERTY.EVEN
var current_idx : int = 0
var b_idx : int = 0
var stopped : bool = false

var c_idx : int = 0

var original_colors = []
var original_colors_b = []

var inner_loop : bool = true

var pseudocode_lines = [
	"function MergeSort",
	"\tint q, i, j;",
	"\tfor i = 1 to N and j = 1 to M do",
	"\t\tif A(i) < B(j) then C(q) = A(i); i = i + 1",
	"\t\tif A(i) = B(j) then C(q) = A(i); i = i + 1; j = j + 1",
	"\t\tif A(i) > B(j) then C(q) = B(j); j = j + 1",
	"\t\tq = q + 1",
	"\tend",
	"",
	"\tfor i = 1 to N do",
	"\t\tq = q + 1",
	"\t\tC(q) = A(i)",
	"\tend",
	"",
	"\tfor j = 1 to M do",
	"\t\tq = q + 1",
	"\t\tC(q) = B(j)",
	"\tend",
	"end"
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
	$ReadButton.pressed.connect(self._on_read_button_pressed)


func _on_read_button_pressed():
	$DescriptionDialog.show()


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


func _on_index_changed(idx, which):
	_update_info_label()
	
	match which:
		"a":
			bars[current_idx - 1].color = original_colors[current_idx - 1]
		"b":
			bars_b[b_idx - 1].color = original_colors_b[b_idx - 1]


func _update_info_label():
	$InfoLabel.clear()
	$InfoLabel.append_text("[b][color=orange]PARAMETERS[/color][/b]")
	$InfoLabel.newline()
	$InfoLabel.append_text("i = %d\t\tj = %d\t\tq = %d" % [current_idx, b_idx, c_idx])


func _on_options_button_pressed(id):
	match id:
		0:
			_reset()
			_generate_values()
		1:
			_reset()


func _get_color_distance(c1, c2) -> float:
	var r_m = (c1.r8 + c2.r8) / 2
	var d_r = (c1.r8 - c2.r8)
	var d_g = (c1.g8 - c2.g8)
	var d_b = (c1.b8 - c2.b8)

	return sqrt((((512 + r_m)*d_r *d_r) >> 8) + 4*d_g *d_g + (((767 - r_m)*d_b*d_b) >> 8))


func _get_random_color():
	var color = Color(randf(), randf(), randf())
	
	var dist_red = _get_color_distance(color, Color.RED)
	var dist_lime = _get_color_distance(color, Color.LIME)
	
	var threshold = 196.0
	
	if dist_red <= threshold or dist_lime <= threshold:
		color = _get_random_color()

	return color


func _reset():
	if temp_color and current_idx <= values.size() - 1:
		bars[current_idx].color = temp_color
	elif temp_color and current_idx == values.size():
		bars[current_idx - 1].color = temp_color
	current_idx = 0
	temp_color = null
	
	if bars_c:
		for bar in bars_c:
			remove_child(bar)
		bars_c = []
	
	b_idx = 0
	c_idx = 0
	
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
	
	if bars_b:
		for bar in bars:
			remove_child(bar)
		bars_b = []
	
	for i in range(5):
		var value = randi_range(10, 100)
		values.append(value)
	values.sort()
	
	for i in range(values.size()):
		var value = values[i]
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
		
		original_colors.append(Color(bar.color))

	for i in range(5):
		var value = randi_range(10, 100)
		values_b.append(value)
	values_b.sort()
	
	for i in range(values_b.size()):
		var value = values_b[i]
		
		var bar = ColorRect.new()
		bar.size = Vector2(32, 32)
		bar.position = Vector2(70, 20 + (40 * i))
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
		
		bars_b.append(bar)
		add_child(bar)
		
		original_colors_b.append(Color(bar.color))


func _return_to_menu():
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _is_prime(num: int) -> bool:
	for i in range(2, int(sqrt(num)) + 1):
		if num % i == 0:
			return false
	return true


func _duplicate_bar(old_bar, text, idx):
	var bar = ColorRect.new()
	bar.size = old_bar.size
	bar.color = _get_random_color()
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
	if current_idx == 0 and b_idx == 0:
		_highlight_code_line(0)
		await get_tree().create_timer(0.5).timeout
		_highlight_code_line(1)
		await get_tree().create_timer(0.5).timeout
		
	if current_idx < values.size() and b_idx < values_b.size():	
		var bar_a = bars[current_idx]
		var bar_b = bars_b[b_idx]
			
		bar_a.color = Color.RED
		bar_b.color = Color.RED

		_highlight_code_line(2)
		await get_tree().create_timer(0.5).timeout

		if values[current_idx] <= values_b[b_idx]:
			_highlight_code_line(3)
			await get_tree().create_timer(0.5).timeout
			
			bar_a.color = Color.LIME
			
			values_c.append(values[current_idx])
			
			var bar = _duplicate_bar(bars[current_idx], values[current_idx], current_idx)
			
			bars_c.append(bar)
			add_child(bar)
			
			var tween = create_tween()
			tween.tween_property(bar, "position", Vector2(130, 20 + (40 * c_idx)), 0.5)
			
			current_idx += 1
			c_idx += 1
			index_changed.emit(current_idx, "a")
		else:
			_highlight_code_line(5)
			await get_tree().create_timer(0.5).timeout
			
			bar_b.color = Color.LIME
			
			values_c.append(values_b[b_idx])
			
			var bar = _duplicate_bar(bars_b[b_idx], values_b[b_idx], b_idx)
			
			bars_c.append(bar)
			add_child(bar)
			
			var tween = create_tween()
			tween.tween_property(bar, "position", Vector2(130, 20 + (40 * c_idx)), 0.5)
			
			b_idx += 1
			c_idx += 1
			index_changed.emit(b_idx, "b")

		_highlight_code_line(6)
		await get_tree().create_timer(0.5).timeout

	elif current_idx < values.size():
		
		_highlight_code_line(9)
		await get_tree().create_timer(0.5).timeout
		
		values_c.append(values[current_idx])
		
		var bar = _duplicate_bar(bars[current_idx], values[current_idx], current_idx)
		
		bars_c.append(bar)
		add_child(bar)
		
		_highlight_code_line(10)
		await get_tree().create_timer(0.5).timeout
		
		var tween = create_tween()
		tween.tween_property(bar, "position", Vector2(130, 20 + (40 * c_idx)), 0.5)
		
		current_idx += 1
		c_idx += 1
		index_changed.emit(current_idx, "a")
		
		_highlight_code_line(11)
		await get_tree().create_timer(0.5).timeout
		_highlight_code_line(12)
		await get_tree().create_timer(0.5).timeout
	elif b_idx < values_b.size():
		
		_highlight_code_line(14)
		await get_tree().create_timer(0.5).timeout
		
		values_c.append(values_b[b_idx])
		
		var bar = _duplicate_bar(bars_b[b_idx], values_b[b_idx], b_idx)
			
		bars_c.append(bar)
		add_child(bar)
		
		_highlight_code_line(15)
		await get_tree().create_timer(0.5).timeout
		
		var tween = create_tween()
		tween.tween_property(bar, "position", Vector2(130, 20 + (40 * c_idx)), 0.5)
		
		b_idx += 1
		c_idx += 1
		index_changed.emit(b_idx, "b")
		
		_highlight_code_line(16)
		await get_tree().create_timer(0.5).timeout
		_highlight_code_line(17)
		await get_tree().create_timer(0.5).timeout
	else:
		_highlight_code_line(18)
		await get_tree().create_timer(0.5).timeout
