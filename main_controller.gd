extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$SumButton.pressed.connect(self._change_scene.bind("sum"))
	$DecisionButton.pressed.connect(self._change_scene.bind("decision"))
	$SelectionButton.pressed.connect(self._change_scene.bind("selection"))

func _change_scene(scene):
	get_tree().change_scene_to_file("res://%s.tscn" % scene)
