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
var max_num : int = 0
var max_idx : int = 0
var next_idx : int = 1
var stopped : bool = false

var first_run : bool = true

var tween

var colors = {}

var pseudocode_lines = [
	"function SwapSort(N, A)",
	"\tloop i=1 to N - 1",
	"\t\tloop j=i+1 to N",
	"\t\t\tif A(i) > A(j) then",
	"\t\t\t\tSwap(A(i), A(j))",
	"\t\t\tend of if",
	"\t\tend of inner loop",
	"\tend of outer loop",
	"end of function",
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


func _on_index_changed(idx, idx2):
	_update_info_label()


func _update_info_label():
	$InfoLabel.clear()


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
	
	max_num = 0
	max_idx = 0
	next_idx = 1

	_update_info_label()
	_reset_pseudocode()
	
	first_run = true

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
		
		colors[value] = Color(bar.color)
		
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
	if current_idx == 0 and first_run:
		_highlight_code_line(0)
		await get_tree().create_timer(0.5).timeout

	_highlight_code_line(1)
	await get_tree().create_timer(0.5).timeout

	if current_idx == values.size() - 1:
		if not stopped:
			_highlight_code_line(7)
			await get_tree().create_timer(0.5).timeout
			_highlight_code_line(8)
			await get_tree().create_timer(0.5).timeout
			stopped = true
		current_idx = 0
		next_idx = 0
		stopped = false
		return
	
	if next_idx == values.size():
		_highlight_code_line(6)
		await get_tree().create_timer(0.5).timeout
		return
	
	next_idx = current_idx + 1

	_highlight_code_line(2)
	await get_tree().create_timer(0.5).timeout
	
	if tween:
		if tween.is_running():
				return
		tween.kill()

	bars[current_idx - 1].color = colors.get(values[current_idx - 1])
	bars[current_idx].color = Color.RED
	
	_highlight_code_line(3)
	await get_tree().create_timer(0.5).timeout
	
	if values[current_idx] > values[next_idx]:
		var bar1 = bars[current_idx]
		var bar2 = bars[next_idx]
		
		bar1.color = Color.LIME
		bar2.color = Color.LIME
		
		var temp_val = values[current_idx]
		values[current_idx] = values[next_idx]
		values[next_idx] = temp_val
		
		var pos1 = bar1.position
		var pos2 = bar2.position
		
		_highlight_code_line(4)
		await get_tree().create_timer(0.5).timeout
		
		tween = get_tree().create_tween()
		tween.tween_property(bar1, "position", pos2, 0.5)
		tween.tween_property(bar2, "position", pos1, 0.5)
		
		tween.finished.connect(self._update_bars.bind(bar1, bar2, current_idx, next_idx))
	
	_highlight_code_line(5)
	await get_tree().create_timer(0.5).timeout
	
	next_idx += 1
	current_idx += 1
	index_changed.emit(current_idx, next_idx)



func _update_bars(bar1, bar2, idx1, idx2):
	bar1.color = colors.get(values[idx2])
	bar2.color = colors.get(values[idx1])
	bars[idx1] = bar2
	bars[idx2] = bar1
