extends Node2D

var mplayer

# Called when the node enters the scene tree for the first time.
func _ready():
	mplayer = get_node("MidiPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("test"):
		mplayer.play()


func _on_midi_player_appeared_lyric(lyric):
	print("lyric: " + str(lyric))
	if Input.is_action_pressed(str(lyric)):
		print("hit")
