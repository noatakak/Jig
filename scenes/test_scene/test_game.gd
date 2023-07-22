extends Node2D

var mplayer
var ui
var buffer

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

# Called when the node enters the scene tree for the first time.
func _ready():
	mplayer = get_node("MidiPlayer")
	ui = get_node("keys")
	ui.visible = false
	
	buffer = 0.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("test"):
		ui.visible = true
		mplayer.play()


# gets a signal on lyric appearance
func _on_midi_player_appeared_lyric(lyric):
	print("lyric: " + str(lyric))
	if Input.is_action_pressed(str(lyric)):
		print("hit")
