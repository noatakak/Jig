extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") and !get_node("MainMenu").visible:
		get_node("PauseContainer").visible = true
		get_tree().paused = true
		


func _on_button_pressed():
	get_node("MainMenu").visible = false
	# start game



func _on_pause_button_pressed():
	get_node("PauseContainer").visible = false
	get_node("MainMenu").visible = true
	get_tree().paused = false
	# stop game
	
