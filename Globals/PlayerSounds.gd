extends Node2D




onready var death_sound = $DeathSound
onready var damage_sound = $DamageSound

func sound_played(sound):
	print("Test")
	if sound == "player_death":
		death_sound.play()
	elif sound == "enemy_death":
		death_sound.play()
	elif sound == "enemy_damage":
		damage_sound.play()
	elif sound == "player_damage":
		damage_sound.play()
	elif sound =="shield_destroyed":
		death_sound.play()
