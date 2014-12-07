
extends Area

# member variables here, example:
# var a=2
# var b="textvar"

var contact = []

func _ready():
	set_fixed_process(true)
	pass

var life_time_left = 20.0
func _fixed_process(delta):
	
	life_time_left -= delta
	if (life_time_left < 0.0):
		for i in contact:
			i.leave_snow()
		queue_free()
	#print (life_time_left)




func _on_KinematicBody_body_enter( body ):
	var body_name = body.get_name()
	if ( body_name.begins_with("snowman") or body_name.begins_with("human") ):
		if (body_name.begins_with("snowman_spawn") or body_name.begins_with("human_spawn")):
			return
		contact.append(body)
		body.enter_snow()
	pass # replace with function body


func _on_KinematicBody_body_exit( body ):
	var body_name = body.get_name()
	if ( body_name.begins_with("snowman") or body_name.begins_with("human") ):
		if (body_name.begins_with("snowman_spawn") or body_name.begins_with("human_spawn")):
			return
		contact.erase(body)
		body.leave_snow()
	pass # replace with function body
