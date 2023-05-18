extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$SumButton.pressed.connect(self._change_scene.bind("algorithms/simple/sum"))
	$DecisionButton.pressed.connect(self._change_scene.bind("algorithms/simple/decision"))
	$SelectionButton.pressed.connect(self._change_scene.bind("algorithms/simple/selection"))
	$SearchButton.pressed.connect(self._change_scene.bind("algorithms/simple/search"))
	$CountingButton.pressed.connect(self._change_scene.bind("algorithms/simple/counting"))
	$MaxValSelectionButton.pressed.connect(self._change_scene.bind("algorithms/simple/max_selection"))
	
	$AssortmentButton.pressed.connect(self._change_scene.bind("algorithms/complex/assortment"))
	$SplitSelButton.pressed.connect(self._change_scene.bind("algorithms/complex/split_selection"))
	$IntersectionButton.pressed.connect(self._change_scene.bind("algorithms/complex/intersection"))
	$UnionButton.pressed.connect(self._change_scene.bind("algorithms/complex/union"))
	$ConcatButton.pressed.connect(self._change_scene.bind("algorithms/complex/merge_sort"))
	$SortingButton.pressed.connect(self._change_scene.bind("algorithms/complex/sort"))

func _change_scene(scene):
	get_tree().change_scene_to_file("res://%s.tscn" % scene)
