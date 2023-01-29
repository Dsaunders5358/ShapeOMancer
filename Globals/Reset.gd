extends Node2D


func _ready():
	$Timer.start()


func _on_Timer_timeout():
	print("Transitioning")
	SceneTransition.change_scene("res://Main.tscn")
