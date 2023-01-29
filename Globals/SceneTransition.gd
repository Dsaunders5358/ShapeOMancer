extends CanvasLayer


func change_scene(target):
	$AnimationPlayer.play('dissolve')
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(target)
	$AnimationPlayer.play_backwards('dissolve')
