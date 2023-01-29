extends Node2D


onready var bullet_manager = $BulletManager
onready var player: Player = $Player
onready var player_sounds = $PlayerSounds
onready var spawning = $SpawnPoints
onready var animation_player = $AnimationPlayer

var player_dead = false


func _ready():
	randomize()
	GlobalSignals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")
	GlobalSignals.connect("play_sound", player_sounds, "sound_played")
	GlobalSignals.connect("shield_destroy", player, "no_shield")
	GlobalSignals.connect("enemy_death", spawning, "enemy_died" )
	$AnimationPlayer.play("enter_scene")
	$Player.hide()
	$StartTimer.start()
	get_tree().paused = true
	

func _process(_delta):
	if player_dead == true:
		if Input.is_action_just_pressed("continue"):
			SceneTransition.change_scene("res://Reset.tscn")
		elif Input.is_action_just_pressed("quit"):
			SceneTransition.change_scene("res://TitleScreen.tscn")


func _on_StartTimer_timeout():
	$Player.show()


func _on_SpawnPoints_wave_ended():
	$AnimationPlayer.play("scene_change")


func _on_AnimationPlayer_animation_finished(scene_change):
	if scene_change == "scene_change":
		SceneTransition.change_scene("res://InstructionScreen.tscn")


func _on_Player_dead():
	player_dead = true
	$Label.show()
