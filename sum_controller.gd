extends Control

var total_value = 0
var values = []

var current_idx = 0
var sum = 0

var tween

var stopped = false

var pseudocode_lines = [
	"function Sum(N, A, sum)",
	"\tsum = 0",
	"\tloop i=1 to N",
	"\t\tsum = sum + A(i)",
	"\tend of loop",
	"end of function"
]

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

func _ready():
	_regenerate_values()
	_reset_pseudocode()
	$OptionsButton.get_popup().id_pressed.connect(self._on_options_button_pressed)
	$ReadButton.pressed.connect(self._on_read_button_pressed)
	$RunButton.pressed.connect(self._on_run_button_pressed)
	$ReturnButton.pressed.connect(self._return_to_menu)

func _return_to_menu():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_run_button_pressed():
	if current_idx == values.size():
		if not stopped:
			await get_tree().create_timer(0.5).timeout
			stopped = true
			_highlight_code_line(4)
			await get_tree().create_timer(0.5).timeout
			_highlight_code_line(5)
		return

	if current_idx == 0:
		_highlight_code_line(0)
		await get_tree().create_timer(0.5).timeout
		_highlight_code_line(1)
		await get_tree().create_timer(0.5).timeout

	_highlight_code_line(2)
	await get_tree().create_timer(0.5).timeout

	if current_idx < len(values):
		if tween:
			if tween.is_running():
				return
			tween.kill()
		
		tween = create_tween()
		
		var value = values[current_idx]
		
		sum += value
		_highlight_code_line(3)
		await tween.tween_property($ProgressBar, "value", value, 1).as_relative()
		
		_update_sum_label(false, value)
		
		current_idx += 1

func _on_options_button_pressed(id):
	if id == 0:
		_regenerate_values()
	elif id == 1:
		_reset()

func _on_read_button_pressed():
	$DescriptionDialog.show()

func _update_sum_label(reset, diff=0):
	var idx = current_idx + 1
	
	if reset == true:
		idx = current_idx
	
	$SumLabel.clear()
	if diff > 0:
		$SumLabel.append_text("sum = %d [color=green](+%d)[/color]" % [sum, diff])
		_highlight_array_element(current_idx)
	else:
		$SumLabel.append_text("sum = %d" % sum)
	$SumLabel.newline()
	$SumLabel.append_text("i = %d" % idx)

func _reset():
	if tween:
		if tween.is_running():
			return
		tween.kill()

	tween = create_tween()
	tween.tween_property($ProgressBar, "value", 0, 1)
	$ProgressBar.max_value = total_value
	
	sum = 0
	current_idx = 0
	
	stopped = false
	
	_update_sum_label(true)
	_reset_pseudocode()
	_reset_array_label()


func _highlight_array_element(idx):
	$ArrayLabel.clear()
	$ArrayLabel.append_text("A = [")
	for i in range(values.size()):
		var value = values[i]
		if idx == i:
			$ArrayLabel.append_text("[color=red]%d[/color]" % value)
		else:
			$ArrayLabel.append_text("%d" % value)
		
		if i < len(values) - 1:
			$ArrayLabel.append_text(", ")
		else:
			$ArrayLabel.append_text("]")


func _reset_array_label():
	$ArrayLabel.clear()
	$ArrayLabel.append_text("A = [")
	
	for idx in range(values.size()):
			var num = values[idx]
			$ArrayLabel.append_text(str(num))
			if idx < len(values) - 1:
				$ArrayLabel.append_text(", ")
			else:
				$ArrayLabel.append_text("]")

func _regenerate_values():
	_reset()

	values = []
	total_value = 0
	
	for i in range(10):
		var value = randi_range(1, 20)
		total_value += value
		values.append(value)
	
	$ProgressBar.max_value = total_value
	
	_reset_array_label()
