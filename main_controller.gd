extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$SumButton.pressed.connect(self._change_scene.bind("algorithms/simple/sum"))
	$DecisionButton.pressed.connect(self._change_scene.bind("algorithms/simple/decision"))
	$SelectionButton.pressed.connect(self._change_scene.bind("algorithms/simple/selection"))
	$SearchButton.pressed.connect(self._change_scene.bind("algorithms/simple/search"))
	$CountingButton.pressed.connect(self._change_scene.bind("algorithms/simple/counting"))
	$MaxValSelectionButton.pressed.connect(self._change_scene.bind("algorithms/simple/max_selection"))

func _change_scene(scene):
	get_tree().change_scene_to_file("res://%s.tscn" % scene)
