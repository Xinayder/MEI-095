extends Control

var total_value = 0
var values = []

var current_idx = 0
var sum = 0

var tween

func _ready():
	_regenerate_values()
	$OptionsButton.get_popup().id_pressed.connect(self._on_options_button_pressed)
	$ReadButton.pressed.connect(self._on_read_button_pressed)
	$RunButton.pressed.connect(self._on_run_button_pressed)
	$ReturnButton.pressed.connect(self._return_to_menu)

func _return_to_menu():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_run_button_pressed():
	if current_idx < len(values):
		if tween:
			if tween.is_running():
				return
			tween.kill()
		
		tween = create_tween()
		
		var value = values[current_idx]
		
		sum += value
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
	
	_update_sum_label(true)

func _regenerate_values():
	values = []
	total_value = 0
	
	$ArrayLabel.clear()
	$ArrayLabel.append_text("A = [")
	
	for i in range(10):
		var value = randi_range(1, 20)
		total_value += value
		values.append(value)
	
	$ProgressBar.max_value = total_value
	
	for idx in range(values.size()):
			var num = values[idx]
			$ArrayLabel.append_text(str(num))
			if idx < len(values) - 1:
				$ArrayLabel.append_text(", ")
			else:
				$ArrayLabel.append_text("]")
