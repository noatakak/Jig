extends Node

var note_list
var note_container

var a_start
var s_start
var d_start
var f_start

var a_target
var s_target
var d_target
var f_target

var lerp_start = 0.4

@export var milisec_view: int = 2000

func _ready():
	note_container = get_node("note_container")
	a_start = get_node("a_start")
	s_start = get_node("s_start")
	d_start = get_node("d_start")
	f_start = get_node("f_start")
	
	a_target = get_node("a_target")
	s_target = get_node("s_target")
	d_target = get_node("d_target")
	f_target = get_node("f_target")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for note in note_container.get_children():
		if note.position.y >= a_target.position.y:
			note.queue_free()


func update_note_list(new_list):
	milisec_view = randi_range(500,2000)
	note_list = new_list
	for child in note_container.get_children():
		child.queue_free()
	var note = load("res://scenes/note.tscn")
	for n in note_list:
		var note_node = note.instantiate()
		note_node.position.y = a_start.position.y
		note_node.position.x = 64
		note_node.scale.x = 0
		note_node.scale.y = 0
		note_node.set_meta("play_time", n.time)
		note_node.set_meta("letter", n.event.args["text"])
		note_container.add_child(note_node)



# distance = note.get_meta("play_time") - time
# if distnace <= milisec_view:
#	t = (milisec_view - distance)/milisec_view
#	note.position = a_target.start.lerp(a_target.posiiton, t)
# 	var scale = lerp(0.0, 1.0, t)
#	note.scale.x = scale
# 	note.scale.y = scale
func move_notes(time):
	for note in note_container.get_children():
		var distance = note.get_meta("play_time") - time
		if distance <= milisec_view:
			if note.get_meta("letter") == "a ":
				var t = (milisec_view - distance)/milisec_view
				note.position = a_start.position.lerp(a_target.position, t)
				var scale = lerp(lerp_start, 1.0, t)
				note.scale.x = scale
				note.scale.y = scale
			if note.get_meta("letter") == "s ":
				var t = (milisec_view - distance)/milisec_view
				note.position = s_start.position.lerp(s_target.position, t)
				var scale = lerp(lerp_start, 1.0, t)
				note.scale.x = scale
				note.scale.y = scale
			if note.get_meta("letter") == "d ":
				var t = (milisec_view - distance)/milisec_view
				note.position = d_start.position.lerp(d_target.position, t)
				var scale = lerp(lerp_start, 1.0, t)
				note.scale.x = scale
				note.scale.y = scale
			if note.get_meta("letter") == "f ":
				var t = (milisec_view - distance)/milisec_view
				note.position = f_start.position.lerp(f_target.position, t)
				var scale = lerp(lerp_start, 1.0, t)
				note.scale.x = scale
				note.scale.y = scale
