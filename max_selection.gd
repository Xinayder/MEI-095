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

func _on_index_changed(idx):
	_update_info_label()


func _update_info_label():
	$InfoLabel.clear()
	$InfoLabel.append_text("max = %d, index = %d" % [max_num, max_idx])


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

	_update_info_label()

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
	if current_idx == values.size():
		return
	
	if temp_color:
		bars[current_idx - 1].color = temp_color
	
	temp_color = bars[current_idx].color
	bars[current_idx].color = Color.RED
	
	if values[current_idx] > max_num:
		bars[current_idx].color = Color.LIME
		max_num = values[current_idx]
		max_idx = current_idx
	
	current_idx += 1
	index_changed.emit(current_idx)
