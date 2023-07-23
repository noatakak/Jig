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
	$ButtonClick.play()
	get_node("MainMenu").visible = false
	get_node("EndWindow").visible = false
	midi_game.score = 0
	midi_game.mplayer.position = 0
	for child in midi_game.get_node("note_manager/note_container").get_children():
		child.queue_free()
	midi_game.visible = true
	midi_game.casted_flag = false
	midi_game.set_process(true)



func _on_quit_button_pressed():
	$ButtonClick.play()
	midi_game.score = 0
	midi_game.mplayer.stop()
	midi_game.mplayer.position = 0
	for child in midi_game.get_node("note_manager/note_container").get_children():
		child.queue_free()
	midi_game.ui.visible = false
	midi_game.visible = false
	get_node("PauseWindow").visible = false
	get_node("MainMenu").visible = true
	get_tree().paused = false
	midi_game.get_node("BoatSprite/ReelAnimation").visible = false
	midi_game.get_node("BoatSprite/ReelAnimation").stop()	
	midi_game.get_node("BoatSprite/CastAnimation").visible = false
	midi_game.get_node("BoatSprite/CastAnimation").stop()
	midi_game.get_node("BoatSprite/CastIdleAnimation").visible = false
	midi_game.get_node("BoatSprite/CastIdleAnimation").stop()		
	midi_game.get_node("BoatSprite/IdleAnimation").visible = true	
	midi_game.casted_flag = false
	midi_game.set_process(false)
