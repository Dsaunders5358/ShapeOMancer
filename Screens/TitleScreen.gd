extends Node2D


func _ready():
	$AnimationPlayer.play("any_key")
	$AnimationPlayer.play("float_anim")

func _process(delta):
	pass

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			$AnimationPlayer.play("audio_fade")
			GlobalSignals.victory_message = null
			SceneTransition.change_scene("res://InstructionScreen.tscn")
