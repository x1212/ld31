
extends Spatial

# member variables here, example:
# var a=2
# var b="textvar"

var snowman_class = preload("res://snowman.scn")


func _ready():
	set_process(true)
	pass



var COOLDOWN_MAX = 2.0
var cooldown = COOLDOWN_MAX
var MAX_SNOWMEN = 30
var next_snowman_id = 0
var my_level = 0
var live_max = 10
var live = live_max
func _process(delta):
	
	
	
	cooldown -= delta
	
	if (cooldown < 0.0 and get_parent().get_parent().get_node("obj").get_child_count() < MAX_SNOWMEN):
		cooldown = COOLDOWN_MAX
		var new_snowman = snowman_class.instance()#get_child(0).duplicate()
		new_snowman.set_translation(get_translation()*Vector3(1.0,0.0,1.0)+Vector3(0.0,0.15,0.0))
		var name = "snowman"+str(next_snowman_id)
		next_snowman_id += 1
		print(name + " spawned")
		new_snowman.set_name(name)
		get_parent().get_parent().get_node("obj").add_child(new_snowman)
		new_snowman.show()
	#print("snowman spawned")
	
	get_node("KinematicBody").life_time_left=20.0
	
	if (live <= 0):
		queue_free()
	pass


func _on_snowmen_body_enter( body ):
	if (body extends Node):
		if (body.get_name().begins_with("human")):
			live -= body.my_level + 1
			body.queue_free()
		elif (body.get_name().begins_with("snowman") and live < live_max):
			live += body.my_level + 1
			body.queue_free()
	pass # replace with function body
