extends Node2D


export (PackedScene) var Enemy


signal wave_ended


onready var top_left = $Spawn1
onready var top_middle_left = $Spawn2
onready var top_middle_right = $Spawn3
onready var top_right = $Spawn4
onready var bottom_left = $Spawn5
onready var bottom_middle_left = $Spawn6
onready var bottom_middle_right = $Spawn7
onready var bottom_right = $Spawn8
onready var left = $Spawn9
onready var right = $Spawn10
onready var center = $Spawn11
onready var wave_spawner = $WaveSpawner
onready var enemy_spawn = $EnemySpawn


var spawn_row = 1
var spawn_wave = 1 
var count = 1
var spawn_points
var rng
var current_spawn_number = 1
var enemy_count = 0
var random_wave
var kill_count = 0

func _ready():
	print("Spawner Ready")
	rng = RandomNumberGenerator.new()
	wave_spawner.start()

func _process(_delta):
	if kill_count == 30:
		GlobalSignals.victory_message = "Winner"
		emit_signal("wave_ended")

func _on_WaveSpawner_timeout():
	match current_spawn_number:
		1:
			print("Starting Wave 1")
			spawn_static_wave([[top_left, "Triangle"], [bottom_left, "Triangle"]])
		2:
			print("Starting Wave 2")
			spawn_static_wave([[top_right, "Triangle"], [bottom_right, "Triangle"]])
		3:
			print("Starting Wave 3")
			spawn_static_wave([[top_left, "Triangle"], [left, "Triangle"], [bottom_left, "Triangle"], [bottom_middle_left, "Triangle"]])
		4:
			print("Starting Wave 4")
			spawn_static_wave([[top_right, "Triangle"], [right, "Triangle"], [bottom_right, "Triangle"], [top_middle_right, "Triangle"]])
		5:
			print("Starting Wave 5")
			spawn_static_wave([[top_left, "Triangle"], [top_right, "Triangle"], [bottom_left, "Triangle"], [bottom_right, "Triangle"]])
		6:
			print("Starting Wave 6")
			spawn_random_wave([[top_left,"Square"], [top_right, "Square"], [bottom_left, "Square"], [bottom_right, "Square"]])
		7:
			print("Starting Wave 7")
			spawn_random_wave([[top_left, "Triangle"], [top_middle_left, "Triangle"], [top_middle_right, "Triangle"], [top_right, "Triangle"], [bottom_left, "Triangle"], [bottom_middle_left, "Triangle"], [bottom_middle_right, "Triangle"], [bottom_right, "Triangle"], [left, "Square"], [right, "Square"]])
func spawn_static_wave(enemies):
	for enemy in enemies:
		var enemy_instance = Enemy.instance()
		enemy_instance.set("shape", enemy[1])
		enemy_instance.global_position = enemy[0].global_position
		add_child(enemy_instance)
	current_spawn_number += 1
	enemy_count += len(enemies)

func spawn_random_wave(enemies):
	random_wave = enemies
	print(random_wave)
	enemy_spawn.start(0.0)
	
func _on_EnemySpawn_timeout():
	wave_spawner.stop()
	print(len(random_wave))
	var wave_count = count
	if wave_count > len(random_wave):
		enemy_spawn.stop()
		current_spawn_number += 1
		wave_spawner.start(0.0)
		print(enemy_count)
		return
	else:
		rng.randomize()
		var i = rng.randi_range(0, len(random_wave) - 1)
		var enemy = random_wave[i]
		random_wave.pop_at(i)
		var enemy_instance = Enemy.instance()
		enemy_instance.set("shape", enemy[1])
		enemy_instance.global_position = enemy[0].global_position
		add_child(enemy_instance)
		enemy_count += 1
		
func enemy_died():
	kill_count += 1
	print(kill_count)
