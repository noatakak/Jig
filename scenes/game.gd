extends Node2D

var midi_game
# Called when the node enters the scene tree for the first time.
func _ready():
	midi_game = get_node("midi_game")
	midi_game.visible = false
	midi_game.set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause") and !get_node("MainMenu").visible:
		get_node("PauseWindow").visible = true
		get_tree().paused = true


func _on_button_pressed():
	get_node("MainMenu").visible = false
	midi_game.visible = true
	midi_game.set_process(true)
	# start game


func _on_pause_button_pressed():
	get_node("PauseWindow").visible = false
	get_node("MainMenu").visible = true
	midi_game.visible = false
	midi_game.set_process(false)
	get_tree().paused = false
	# stop game
	
