extends Node2D

var mplayer
var ui
@export var buffer: float
var score

var key_a_flag 
var key_s_flag
var key_d_flag
var key_f_flag

var key_a_timer
var key_s_timer
var key_d_timer
var key_f_timer

var note_a_flag
var note_s_flag
var note_d_flag
var note_f_flag

var note_a_timer
var note_s_timer
var note_d_timer
var note_f_timer

var timer_container

var a_poly
var s_poly
var d_poly
var f_poly

# Called when the node enters the scene tree for the first time.
func _ready():
	mplayer = get_node("MidiPlayer")
	ui = get_node("keys")
	ui.visible = false
	
	score = 0
	buffer = 0.2
	
	a_poly = get_node("keys/Polygon2D")
	s_poly = get_node("keys/Polygon2D2")
	d_poly = get_node("keys/Polygon2D3")
	f_poly = get_node("keys/Polygon2D4")
	
	# intitalize timers and flags
	key_a_flag = false
	key_s_flag = false
	key_d_flag = false
	key_f_flag = false
	
	note_a_flag = false
	note_s_flag = false
	note_d_flag = false
	note_f_flag = false
	
	timer_container = Node.new()
	timer_container.set_name("timer_container")
	
	key_a_timer = Timer.new()
	key_a_timer.set_name("key_a_timer")
	key_s_timer = Timer.new()
	key_s_timer.set_name("key_s_timer")
	key_d_timer = Timer.new()
	key_d_timer.set_name("key_d_timer")
	key_f_timer = Timer.new()
	key_f_timer.set_name("key_f_timer")
	
	note_a_timer = Timer.new()
	note_a_timer.set_name("note_a_timer")
	note_s_timer = Timer.new()
	note_s_timer.set_name("note_s_timer")
	note_d_timer = Timer.new()
	note_d_timer.set_name("note_d_timer")
	note_f_timer = Timer.new()
	note_f_timer.set_name("note_f_timer")
	
	timer_container.add_child(key_a_timer)
	timer_container.add_child(key_s_timer)
	timer_container.add_child(key_d_timer)
	timer_container.add_child(key_f_timer)
	timer_container.add_child(note_a_timer)
	timer_container.add_child(note_s_timer)
	timer_container.add_child(note_d_timer)
	timer_container.add_child(note_f_timer)
	
	add_child(timer_container)
	
	for t in timer_container.get_children():
		t.wait_time = buffer
		t.one_shot = true
		t.connect("timeout", Callable(self, "_on_" + t.get_name() + "_timeout"))
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_node("keys/score").text = "Score: " + str(score)
	# hit space to make ui visible and start music
	if Input.is_action_pressed("test") and not mplayer.playing:
		ui.visible = true
		mplayer.play()
		
	if mplayer.playing:
		if key_a_flag and note_a_flag:
			a_poly.color = "2a983c"
			key_a_flag = false
			note_a_flag = false
			score += 1
		if key_s_flag and note_s_flag:
			s_poly.color = "2a983c"
			key_s_flag = false
			note_s_flag = false
			score += 1
		if key_d_flag and note_d_flag:
			d_poly.color = "2a983c"
			key_d_flag = false
			note_d_flag = false
			score += 1
		if key_f_flag and note_f_flag:
			f_poly.color = "2a983c"
			key_f_flag = false
			note_f_flag = false
			score += 1


# gets a signal on lyric appearance
func _on_midi_player_appeared_lyric(lyric):
	print("lyric: " + str(lyric))
	if str(lyric) == "a ":
		note_a_flag = true
		note_a_timer.start()
	if str(lyric) == "s ":
		note_s_flag = true
		note_s_timer.start()
	if str(lyric) == "d ":
		note_d_flag = true
		note_d_timer.start()
	if str(lyric) == "f ":
		note_f_flag = true
		note_f_timer.start()


func _input(event):
	if event.is_action_pressed("a "):
		key_a_flag = true
		key_a_timer.start()
		a_poly.color = 606060
	if	event.is_action_pressed("s "):
		key_s_flag = true
		key_s_timer.start()
		s_poly.color = 606060
	if event.is_action_pressed("d "):
		key_d_flag = true
		key_d_timer.start()
		d_poly.color = 606060
	if event.is_action_pressed("f "):
		key_f_flag = true
		key_f_timer.start()
		f_poly.color = 606060


# timer functions
func _on_key_a_timer_timeout():
	if key_a_flag:
		key_a_flag = false
		score -= 1
	a_poly.color = "ffffff"
func _on_key_s_timer_timeout():
	if key_s_flag:
		key_s_flag = false
		score -= 1
	s_poly.color = "ffffff"
func _on_key_d_timer_timeout():
	if key_d_flag:
		key_d_flag = false
		score -= 1
	d_poly.color = "ffffff"
func _on_key_f_timer_timeout():
	if key_f_flag:
		key_f_flag = false
		score -= 1
	f_poly.color = "ffffff"

func _on_note_a_timer_timeout():
	note_a_flag = false
	score -= 1
	a_poly.color = "ffffff"
func _on_note_s_timer_timeout():
	note_s_flag = false
	score -= 1
	s_poly.color = "ffffff"
func _on_note_d_timer_timeout():
	note_d_flag = false
	score -= 1
	d_poly.color = "ffffff"
func _on_note_f_timer_timeout():
	note_f_flag = false
	score -= 1
	f_poly.color = "ffffff"
