extends Timer


func _on_StartTimer_timeout():
	get_tree().paused = false
