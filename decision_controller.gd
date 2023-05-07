extends Control

var values = []
var bars = []
var temp_color

# Called when the node enters the scene tree for the first time.
func _ready():
	$ReturnButton.pressed.connect(self._return_to_menu)
	$OptionsButton.get_popup().hide_on_checkable_item_selection = false
	$OptionsButton.get_popup().id_pressed.connect(self._on_options_button_pressed)
	
	_generate_values()

func _on_options_button_pressed(id):
	match id:
		0:
			_generate_values()
		3:
			$OptionsButton.get_popup().toggle_item_checked(id)
			$OptionsButton.get_popup().set_item_checked(4, false)
		4:
			$OptionsButton.get_popup().toggle_item_checked(id)
			$OptionsButton.get_popup().set_item_checked(3, false)

func _get_random_color():
	return Color(randf(), 0, randf())

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
