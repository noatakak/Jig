extends Node2D

var midi_game
# Called when the node enters the scene tree for the first time.
func _ready():
	midi_game = get_node("midi_game")
	midi_game.visible = false
	midi_game.set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Starts game and hides menu
func _on_play_button_pressed():
	get_node("MainMenu").visible = false
	midi_game.visible = true
	midi_game.set_process(true)



func _on_quit_button_pressed():
	midi_game.score = 0
	midi_game.mplayer.stop()
	for child in midi_game.get_node("note_manager/note_container").get_children():
		child.queue_free()
	midi_game.ui.visible = false
	midi_game.visible = false
	get_node("PauseWindow").visible = false
	get_node("MainMenu").visible = true
	get_tree().paused = false
	midi_game.set_process(false)
