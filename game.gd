
extends Spatial

# member variables here, example:
# var a=2
# var b="textvar"

var clouds_class = preload("res://clouds.scn")
var camp_class = preload("res://campfire.scn")

func _ready():
	# Initalization here
	pass




func _on_Spatial_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if (event.is_action("LMB")):
		var new_clouds = clouds_class.instance()
		new_clouds.set_translation(click_pos+Vector3(0.0,1.3,0.0))
		get_node("areas").add_child(new_clouds)
		print("cloudy")
	if (event.is_action("RMB")):
		var new_camp = camp_class.instance()
		new_camp.set_translation(click_pos+Vector3(0.0,0.16,0.0))
		get_node("areas").add_child(new_camp)
		print("burning")
	#print("leave")
	pass # replace with function body
