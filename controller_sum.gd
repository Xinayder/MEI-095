extends Control

var total_value = 0
var values = []
var current_idx = 0
var progressBar
var tween
var pseudocodeLbl
var arrayLbl

var pseudocode_lines = [
	"function Sum(N, A, sum)",
	"\tsum = 0",
	"\tloop i=1 to N",
	"\t\tsum = sum + A(i)",
	"\tend of loop",
	"end of function"
]

func _randomize_values():
	values = []
	
	for i in range(10):
		var value = randi_range(1, 20)
		total_value += value
		values.append(value)
	
	if progressBar:
		progressBar.max_value = total_value
		progressBar.value = 0
	
	if arrayLbl:
		arrayLbl.append_text("A = [")
		for idx in range(values.size()):
			var num = values[idx]
			arrayLbl.append_text(str(num))
			if idx < len(values) - 1:
				arrayLbl.append_text(", ")
			else:
				arrayLbl.append_text("]")

# Called when the node enters the scene tree for the first time.
func _ready():
	arrayLbl = RichTextLabel.new()
	arrayLbl.position = Vector2(0, 25)
	arrayLbl.size = Vector2(300, 50)
	add_child(arrayLbl)
	
	progressBar = ProgressBar.new()
	progressBar.size = Vector2(300, 20)
	progressBar.position = Vector2(0, 50)
	progressBar.max_value = total_value
	progressBar.value = 0
	progressBar.show_percentage = true
	add_child(progressBar)
	
	_randomize_values()

	var button = Button.new()
	button.position = Vector2(0, 100)
	button.text = "Add progress"
	button.pressed.connect(self._on_button_pressed)
	add_child(button)
	
	

	pseudocodeLbl = RichTextLabel.new()
	pseudocodeLbl.bbcode_enabled = true
	pseudocodeLbl.position = Vector2(0, 150)
	pseudocodeLbl.fit_content = true
	pseudocodeLbl.size = Vector2(200, 50)
	
	for line in pseudocode_lines:
		pseudocodeLbl.append_text(line)
		pseudocodeLbl.newline()
	
	add_child(pseudocodeLbl)

func _highlight_line(linenumber, color):
	var lines = pseudocodeLbl.text.split("\n")

	if len(lines) < 1:
		return

	for line in lines:
		if pseudocode_lines[linenumber] == line:
			pseudocodeLbl.append_text("[color=%s]%s[/color]" % [color, line])
		else:
			pseudocodeLbl.append_text(line)
		pseudocodeLbl.newline()

func _dehighlight_line():
	#var lines = label.text.split('\n')
	pseudocodeLbl.clear()

	for line in pseudocode_lines:
		pseudocodeLbl.append_text(line)
		pseudocodeLbl.newline()



func _on_button_pressed():
	if current_idx < len(values):
		var value = values[current_idx]
		_highlight_line(2, "orange")

		if tween:
			tween.kill()

		tween = create_tween()
		tween.tween_property(progressBar, "value", progressBar.value + value, 1)

		_highlight_line(3, "red")

		current_idx += 1

		await tween.finished
		_dehighlight_line()
	else:
		_highlight_line(4, "red")
		#pseudocodeLbl.text = "function Sum(N, A, sum)\n\tsum = 0\n\tloop i=1 to N\n\t\tsum = sum + A(i)\n\t[color=red]end of loop[/color]\nend of function"
		await get_tree().create_timer(0.5).timeout
		#pseudocodeLbl.text = "function Sum(N, A, sum)\n\tsum = 0\n\tloop i=1 to N\n\t\tsum = sum + A(i)\n\tend of loop\n[color=red]end of function[/color]"
		_highlight_line(5, "red")

		tween = create_tween()
		tween.tween_property(progressBar, "value", 0, 1)
		await tween.finished
		current_idx = 0
		_dehighlight_line()
