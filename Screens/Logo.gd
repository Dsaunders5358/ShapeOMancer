extends Node2D

func _ready():
	$Timer.start()


func _on_Timer_timeout():
	SceneTransition.change_scene("res://GameJam.tscn")
