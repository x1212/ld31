
extends KinematicBody

# member variables here, example:
# var a=2
# var b="textvar"

var villager = false
var fighter = false
var new_village

func _ready():
	set_fixed_process(true)
	randomize()
	#print("snowman spawned")
	if (randi()%5 == 1):
		#var new_spawn = load("res://human_spawn.scn").instance()
		#new_spawn.set_translation(Vector3(randi()%3*2.0-3.0,randi()%3*2.0-3.0,randi()%3*2.0-3.0))
		#get_parent().get_parent().get_node("areas").add_child(new_spawn)
		print("!")
		villager = true
		new_village = Vector3(randi()%3*2.0-3.0,randi()%3*2.0-3.0,randi()%3*2.0-3.0)
		#return new_spawn.get_translation()-get_translation()
	
	pass


var in_snow = 0
var in_camp = 0

var live = 10
var live_max = 10
var my_level = 0
var experience = 0
var tick_reset = 1.0
var tick = tick_reset
var enemy_in_range = []
var enemy_in_view = []
var insane_time = 0.0
var old_dir = Vector3(-1.0,0.0,0.0)
func _fixed_process(delta):
	var dir
	tick -= delta
	if (tick<0.0):
		dir = get_goal()
		old_dir = dir
	else:
		dir = old_dir
	#if (is_colliding()):
	#	if(get_collider()!= null and get_collider() extends Node):
	#		#print(get_collider().get_name())
	#		handle_collision()
	#		#if (get_collider().get_name().begins_with("snowman")):
	#		dir = (-get_collision_pos()*Vector3(1.0,0.0,1.0)).normalized()*0.1
	#		pass
	#	else:
	#		#if (get_collider()!= null):
	#		#	print(get_collider().hash())
	#		dir = ((get_translation()-get_collision_pos())*Vector3(1.0,0.0,1.0)).normalized()*0.1
	#		print("unknown collider type")
	handle_collision()
	
	mymove(dir*Vector3(1.0,0.0,1.0), delta)
	if (insane_time > 0.0):
		insane_time -= delta
	
	if (tick <= 0.0):
		tick = tick_reset
		if (in_snow>0):
			live = live + 2
		if (in_camp>0):
			live = live - 2
		live = live + 1
	#	print("456")
	
	if (live > live_max):
		live = live_max
	
	if (live <= 0):
		queue_free()
	
	var old_level = my_level
	my_level = sqrt(experience/10)
	if (my_level > old_level and live > 0):
		live_max += live_max/2
		#live = live_max
	
	pass


func mymove(vec, delta):
	var pos = get_translation()
	var newpos = pos + vec
	vec.x = vec.x+rand_range(-1.0,1.0)
	vec.z = vec.z+rand_range(-1.0,1.0)
	move(vec.normalized()*0.2*delta)
	#set_translation(newpos)


var last_dir = Vector3(0.0,0.0,0.0)
var last_goal = Vector3(0.0,0.0,0.0)
var insane_goal
var last_tick_pos = Vector3(0.0,0.0,0.0)
func get_goal():
	if (insane_time > 0.0):
		return insane_goal
	if ( (last_tick_pos - get_translation()).length() < 0.05 and tick <= 0.0):
		randomize()
		insane_goal = Vector3(rand_range(-1.0,1.0),0.0,rand_range(-1.0,1.0))
		insane_time = 5.0
		#last_tick_pos = get_translation()
		print("going insane")
		return insane_goal
	#print(":)"+str(tick))
	if (tick <= 0.0):
		#print((last_tick_pos - get_translation()).length())
		#print("123")
		last_tick_pos = get_translation()
	if (villager):
		if ((new_village-get_translation()).length()< 1.0):
			var new_spawn = load("res://snowman_spawn.scn").instance()
			new_spawn.set_translation(get_translation())
			get_parent().get_parent().get_node("areas").add_child(new_spawn)
			queue_free()
		#print ((new_village-get_translation()).length())
		if (last_dir.length() > (new_village-get_translation()).length()):
			return last_dir
		last_dir = new_village-get_translation()
		return (new_village-get_translation())
	if (enemy_in_view.size() > 0 and ((tick<=0.0 and randi()%10 > 3 ) or fighter)):
		fighter = true
		return (enemy_in_view[0].get_translation()-get_translation())
	else:
		fighter = false
	var goals = []
	var next_enemy_spawn
	var next_damaged_spawn
	var next_spawn
	var nearest = 20.0
	var ret
	for i in get_parent().get_parent().get_node("areas").get_children():
		if (i.get_name().begins_with("human")):
			if ((i.get_translation()-get_translation()).length() < nearest):
				next_enemy_spawn = i.get_translation()
				nearest = (i.get_translation()-get_translation()).length()
	goals.append(next_enemy_spawn)
	goals.append(next_enemy_spawn)
	goals.append(next_enemy_spawn)
	goals.append(next_enemy_spawn)
	goals.append(next_enemy_spawn)
	goals.append(next_enemy_spawn)
	#if (next_enemy_spawn!=null and (next_enemy_spawn-last_goal).length()<0.02):
	#	return next_enemy_spawn-get_translation()
	nearest = 20.0
	for i in get_parent().get_parent().get_node("areas").get_children():
		if (i.get_name().begins_with("snowman")):
			if ((i.get_translation()-get_translation()).length() < nearest):
				if (i.live < i.live_max):
					next_damaged_spawn = i.get_translation()
					nearest = (i.get_translation()-get_translation()).length()
				next_spawn = i
	if (next_damaged_spawn!=null):
		#goals.append(next_damaged_spawn)
		#goals.append(next_damaged_spawn)
		#goals.append(next_damaged_spawn)
		#goals.append(next_damaged_spawn)
		pass
	#print("?")
	
	if (next_damaged_spawn!=null and (next_damaged_spawn-last_goal).length()<0.1):
		if ((next_damaged_spawn-get_translation()).length()<last_dir.length()):
			return last_dir
		return next_damaged_spawn-get_translation()
	if (next_enemy_spawn!=null and (next_enemy_spawn-last_goal).length()<0.1):
		if ((next_enemy_spawn-get_translation()).length()<last_dir.length()):
			return last_dir
		return next_enemy_spawn-get_translation()
	#goals.append(Vector3(0.0,0.0,0.0))
	
	var n = randi()%goals.size()
	
	if (goals[n] != null):
		return goals[n]-get_translation()
	else:
		insane_goal = Vector3(randi()%3*2.0-3.0,randi()%3*2.0-3.0,randi()%3*2.0-3.0)
		insane_time = 5.0
		#last_tick_pos = get_translation()
		return insane_goal



func enter_snow():
	in_snow += 1
	pass

func leave_snow():
	in_snow -= 1

func enter_camp():
	in_camp += 1
	pass

func leave_camp():
	in_camp -=1

func handle_collision():
	#if (get_collider().get_name().begins_with("human")):
	if (enemy_in_range.size() > 0):
		if (tick <= 0.0):
			experience += enemy_in_range[0].damage(my_level)#get_collider().damage(my_level)
			#print(get_name() + " " + get_collider().get_name())

func damage(level):
	var ret_exp = 0
	var damage_val = clamp(level-my_level, 0, level) + 1
	live -= damage_val*2
	if (level <= my_level):
		ret_exp += 1
	if (live <= 0):
		ret_exp += clamp(level-my_level, 0, my_level)
		ret_exp += 2
	return ret_exp




func _on_Area_body_enter( body ):
	if (body extends Node):
		if (body.get_name().begins_with("human")):
			enemy_in_range.append(body)
	pass # replace with function body


func _on_Area_body_exit( body ):
	if (body extends Node):
		if (body.get_name().begins_with("human")):
			enemy_in_range.erase(body)
	pass # replace with function body


func _on_Area_2_body_enter( body ):
	if (body extends Node):
		if (body.get_name().begins_with("human")):
			enemy_in_view.append(body)
	pass # replace with function body


func _on_Area_2_body_exit( body ):
	if (body extends Node):
		if (body.get_name().begins_with("human")):
			enemy_in_view.erase(body)
	pass # replace with function body
