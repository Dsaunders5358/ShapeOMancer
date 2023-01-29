extends KinematicBody2D



onready var health_stat = $Health
onready var ai = $AI
onready var weapon = $Weapon
onready var death_sound = $DeathSound
onready var path_follow = get_parent()


var shape
var speed = 150
var move_direction = 0

func _ready():
	show()
	if shape == "Triangle":
		$Triangle.show()
		$Square.hide()
		$Health.health = 60
		$CollisionShape2D.disabled = true
		$CollisionPolygon2D.disabled = false
	elif shape == "Square":
		$Triangle.hide()
		$Square.show()
		$Health.health = 80
		$CollisionShape2D.disabled = false
		$CollisionPolygon2D.disabled = true
	$AnimationPlayer.play("spawn")
	ai.initialize(self, weapon, shape)
	
func _process(_delta):
	if health_stat.health > 20 and health_stat.health <= 40 and shape == "Triangle":
		$Triangle.texture = load("res://assets/prototypes/proto-tri-3-cracked.png")
	elif health_stat.health <= 20 and shape == "Triangle":
		$Triangle.texture = load("res://assets/prototypes/proto-tri-3-crackedv.png")
	
	if health_stat.health > 40 and health_stat.health <= 60 and shape == "Square":
		$Square.texture = load("res://assets/prototypes/proto-square-crack.png")
	elif health_stat.health > 20 and health_stat.health <= 40 and shape == "Square":
		$Square.texture = load("res://assets/prototypes/proto-square-crackv.png")
	elif health_stat.health <= 20 and shape == "Square":
		$Square.texture = load("res://assets/prototypes/proto-square-cracka.png")



func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		GlobalSignals.emit_signal("play_sound", "enemy_death")
		GlobalSignals.emit_signal("enemy_death")
		queue_free()
	else:
		GlobalSignals.emit_signal("play_sound", "enemy_damage")

func handle_player_charge():
	GlobalSignals.emit_signal("play_sound", "enemy_death")
	GlobalSignals.emit_signal("enemy_death")
	
	queue_free()


