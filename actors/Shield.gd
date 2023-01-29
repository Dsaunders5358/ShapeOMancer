extends RigidBody2D


signal shield_destroyed


var health = 80


func handle_hit():
	health -= 20
	if health <= 0:
		GlobalSignals.emit_signal("play_sound", "shield_destroyed")
		GlobalSignals.emit_signal("shield_destroy")
		queue_free()
		
func handle_charge(): 
	health -= 20
	if health <= 0:
		GlobalSignals.emit_signal("play_sound", "shield_destroyed")
		GlobalSignals.emit_signal("shield_destroy")
		queue_free()



func _on_Area2D_body_entered(body):
	if body.has_method("handle_player_charge"):
		body.handle_player_charge()
		GlobalSignals.emit_signal("shield_destroy")
		queue_free()
		
