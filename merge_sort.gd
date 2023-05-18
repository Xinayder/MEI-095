extends Node

var series1 = [1, 3, 5, 7, 9]
var series2 = [2, 4, 6, 8, 10]
var mergedSeries = []
var i = 0
var j = 0

func _ready():
	$Button.pressed.connect(self.merge_step)

func merge_step():
	if i < series1.size() and j < series2.size():
		if series1[i] <= series2[j]:
			mergedSeries.append(series1[i])
			print(mergedSeries)
			i += 1
		else:
			mergedSeries.append(series2[j])
			print(mergedSeries)
			j += 1
	elif i < series1.size():
		mergedSeries.append(series1[i])
		print(mergedSeries)
		i += 1
	elif j < series2.size():
		mergedSeries.append(series2[j])
		print(mergedSeries)
		j += 1
	else:
		print(mergedSeries)
