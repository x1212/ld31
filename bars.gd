
extends Spatial

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)
	pass


func _process(delta):
	if (get_parent().live < get_parent().live_max):
		show()
		set_scale(Vector3((1.0*get_parent().live)/(1.0*get_parent().live_max),1.0,1.0))
	else :
		hide()
	if (get_parent().my_level > get_child_count()-1):
		var new_bar = get_child(get_child_count()-1).duplicate()
		add_child(new_bar)
		new_bar.set_offset(get_child(get_child_count()-2).get_offset() + Vector2(0.0,0.1))