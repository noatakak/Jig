extends Node2D

var mplayer
var ui
@export var buffer: float
var score

var lyric_data

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

var casted_flag

var fish_id

# Called when the node enters the scene tree for the first time.
func _ready():
	mplayer = get_node("MidiPlayer")
	ui = get_node("keys")
	ui.visible = false
	
	casted_flag = false
	
	score = 0
	buffer = 0.2
	
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


func load_notes(file: String):
	var smf_reader: = preload("res://addons/old-midi/SMF.gd").new( )
	var result: = smf_reader.read_file(file)
	if result.error == OK:
		print( result.data )
	var midi_data = result.data
	var tracks = midi_data.tracks

	lyric_data = []
	for track in tracks:
		for event in track.events:
			if "args" in event.event and event.event.args["type"] == 5:
				#print(event.event.args["text"])
				lyric_data.append(event)
	lyric_data.sort_custom(func(a,b): return a.time < b.time)
	get_node("note_manager").update_note_list(lyric_data)

func select_song():
	fish_id = randi() % 2 + 1
	if fish_id == 1:
		return "res://assets/midi/midi/Morrisons_Jig-lyrics.mid"
	elif fish_id == 2:
		return "res://assets/midi/midi/Swallowtail_Jig-lyrics.mid"
	else:
		return "res://assets/midi/midi/Irish_washerwoman_Jig-lyrics.mid"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_node("keys/score").text = "Score: " + str(score)
	get_node("note_manager").move_notes(mplayer.position)
	# hit space to make ui visible and start music
	if Input.is_action_pressed("test") and not casted_flag and not mplayer.playing:
		casted_flag = true
		var song = select_song()
		load_notes(song)
		mplayer.file = song
		
		
		$BoatSprite/IdleAnimation.visible = false
		
		$BoatSprite/CastAnimation.visible = true
		$BoatSprite/CastAnimation.play("default")
		await $BoatSprite/CastAnimation.animation_finished	
		get_parent().get_node("Splash1").play()
		
		$BoatSprite/CastAnimation.visible = false
		$BoatSprite/CastIdleAnimation.visible = true		
		$BoatSprite/CastIdleAnimation.play("default")		
		await $BoatSprite/CastIdleAnimation.animation_finished				
		
		$BoatSprite/CastIdleAnimation.visible = false
		$BoatSprite/ReelAnimation.visible = true
		$BoatSprite/ReelAnimation.play("default")										
		
		ui.visible = true
		mplayer.play()
		
	if mplayer.playing:
		if key_a_flag and note_a_flag:
			get_node("keys/NetA").play("green")							
			key_a_flag = false
			note_a_flag = false
			score += 1
			get_parent().get_node("SnareSound").play()
		if key_s_flag and note_s_flag:
			get_node("keys/NetS").play("green")										
			key_s_flag = false
			note_s_flag = false
			score += 1
			get_parent().get_node("SnareSound").play()
		if key_d_flag and note_d_flag:
			get_node("keys/NetD").play("green")										
			key_d_flag = false
			note_d_flag = false
			score += 1
			get_parent().get_node("SnareSound").play()
		if key_f_flag and note_f_flag:
			get_node("keys/NetF").play("green")										
			key_f_flag = false
			note_f_flag = false
			score += 1
			get_parent().get_node("SnareSound").play()


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
		get_node("keys/NetA").play("red")				
	if	event.is_action_pressed("s "):
		key_s_flag = true
		key_s_timer.start()
		get_node("keys/NetS").play("red")						
	if event.is_action_pressed("d "):
		key_d_flag = true
		key_d_timer.start()
		get_node("keys/NetD").play("red")						
	if event.is_action_pressed("f "):
		key_f_flag = true
		key_f_timer.start()
		get_node("keys/NetF").play("red")						


# timer functions
func _on_key_a_timer_timeout():
	if key_a_flag:
		key_a_flag = false
		score -= 1
		get_parent().get_node("DrumSound").play()
	get_node("keys/NetA").play("default")
	
func _on_key_s_timer_timeout():
	if key_s_flag:
		key_s_flag = false
		score -= 1
		get_parent().get_node("DrumSound").play()
	get_node("keys/NetS").play("default")
	
func _on_key_d_timer_timeout():
	if key_d_flag:
		key_d_flag = false
		score -= 1
		get_parent().get_node("DrumSound").play()
	get_node("keys/NetD").play("default")
	
func _on_key_f_timer_timeout():
	if key_f_flag:
		key_f_flag = false
		score -= 1
		get_parent().get_node("DrumSound").play()
	get_node("keys/NetF").play("default")	

func _on_note_a_timer_timeout():
	if note_a_flag:
		note_a_flag = false
		score -= 1
		get_parent().get_node("DrumSound").play()
	get_node("keys/NetA").play("default")
	
func _on_note_s_timer_timeout():
	if note_s_flag:
		note_s_flag = false
		score -= 1
		get_parent().get_node("DrumSound").play()
	get_node("keys/NetS").play("default")	
	
func _on_note_d_timer_timeout():
	if note_d_flag:
		note_d_flag = false
		score -= 1
		get_parent().get_node("DrumSound").play()
	get_node("keys/NetD").play("default")		
	
func _on_note_f_timer_timeout():
	if note_f_flag:
		note_f_flag = false
		score -= 1
		get_parent().get_node("DrumSound").play()
	get_node("keys/NetF").play("default")	
	


func _on_midi_player_finished():
	casted_flag = false
	var end_score: float = float(score) / float(len(lyric_data))
	if end_score > .5:
		if end_score >= .9:
			get_parent().get_node("EndWindow/MarginContainer/Panel/MarginContainer/VBoxContainer/FishPic").set_texture("res://assets/midi/art/ui/bigfish" + str(fish_id) + ".png")
		elif end_score < .9 and end_score >= .7:
			get_parent().get_node("EndWindow/MarginContainer/Panel/MarginContainer/VBoxContainer/FishPic").set_texture("res://assets/midi/art/ui/mediumfish" + str(fish_id) + ".png")
		else:
			get_parent().get_node("EndWindow/MarginContainer/Panel/MarginContainer/VBoxContainer/FishPic").set_texture("res://assets/midi/art/ui/smallfish" + str(fish_id) + ".png")
	else:
		pass
		get_parent().get_node("EndWindow/MarginContainer/Panel/MarginContainer/VBoxContainer/FishPic").set_texture("res://assets/midi/art/ui/bones.png")
	get_node("BoatSprite/ReelAnimation").visible = false
	get_node("BoatSprite/ReelAnimation").stop()	
	get_node("BoatSprite/CastAnimation").visible = false
	get_node("BoatSprite/CastAnimation").stop()
	get_node("BoatSprite/CastIdleAnimation").visible = false
	get_node("BoatSprite/CastIdleAnimation").stop()
	get_node("BoatSprite/IdleAnimation").visible = true	
	ui.visible = false
	get_parent().get_node("EndWindow").visible = true
	get_parent().get_node("Splash2").play()
