extends Node2D

onready var player = $Player
onready var bullet_manager = $BulletManager

func _ready():
	GlobalSignals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")

func _process(_delta):
	if GlobalSignals.victory_message != null:
		$CanvasLayer.hide()
		$Label.show()
	else:
		if player.current_shape == 0:
			$CanvasLayer/Label.show()
			$CanvasLayer/Label3.hide()
			$CanvasLayer/Label4.hide()
		elif player.current_shape == 1:
			$CanvasLayer/Label.hide()
			$CanvasLayer/Label3.show()
			$CanvasLayer/Label4.show()
		
func _unhandled_input(event):
	if event.is_action_pressed("continue"):
		GlobalSignals.victory_message = null
		SceneTransition.change_scene("res://Main.tscn")
		
