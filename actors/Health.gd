extends Node2D


export var health = 200 setget set_health

func set_health(new_health):
	health = clamp(new_health, 0, 200)
