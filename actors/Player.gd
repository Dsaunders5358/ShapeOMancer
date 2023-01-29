extends KinematicBody2D
class_name Player


const pre_shield = preload("res://weapons/Shield.tscn")


signal player_death
signal dead

export var speed = 100
export var max_speed = 800


enum Shape{
	TRIANGLE,
	SQUARE
}


onready var weapon = $Weapon
onready var health_stat = $Health
onready var player_cooldown = $PlayerCooldown
onready var damage_sound = $DamageSound
onready var death_sound = $DeathSound
onready var shape_selector = $ShapeSelector
onready var square_collision = $SquareCollision
onready var triangle_collision = $TriangleCollision
onready var animation_player = $AnimationPlayer
onready var invuln_timer = $InvulnTimer
onready var charge_time = $ChargeTime
onready var charge_duration = $ChargeDuration
onready var shield_cooldown = $ShieldCooldown



var acceleration = 16
var deceleration = 32
var x_slider = 0
var y_slider = 0
var velocity = Vector2.ZERO
var current_shape = 0 setget set_shape
var charged = false
var charging = false
var charge_attack = false
var charge_speed = 400
var square_shield
var have_shield = false



func _ready():
	set_shape(Shape.TRIANGLE)
	
	
func _physics_process(delta):
	
	if charging == true or charged == true and current_shape == Shape.SQUARE and charging == false:
		max_speed = 150
	elif current_shape == Shape.SQUARE:
		max_speed = 300
	if current_shape == Shape.SQUARE and shield_cooldown.is_stopped() == true and have_shield == false:
		summon_shield()
		
	if health_stat.health > 140:
		shape_selector.frame = 0
	elif health_stat.health <= 140 and health_stat.health > 80:
		shape_selector.frame = 1
	elif health_stat.health <= 80 and health_stat.health > 40:
		shape_selector.frame = 2
	elif health_stat.health <= 40 and health_stat.health > 0:
		shape_selector.frame = 3
	
#Movement
	if charge_attack == false:
		if Input.is_action_pressed("right"):
			x_slider += max_speed / acceleration
			if x_slider >= max_speed:
				x_slider = max_speed
				
		if Input.is_action_pressed("left"):
			x_slider -= max_speed / acceleration
			if x_slider <= -max_speed:
				x_slider = -max_speed
				
		if Input.is_action_pressed("up"):
			y_slider -= max_speed / acceleration
			if y_slider <= -max_speed:
				y_slider = -max_speed
				
		if Input.is_action_pressed("down"):
			y_slider += max_speed / acceleration
			if y_slider >= max_speed:
				y_slider = max_speed
		
		#Resetting Movement
		if !Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
			if x_slider > 0:
				x_slider -= max_speed / deceleration
				if x_slider < 0:
					x_slider= 0
			elif x_slider < 0:
				x_slider += max_speed / deceleration
				if x_slider > 0:
					x_slider = 0
		
		if !Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
			if y_slider > 0:
				y_slider -= max_speed / deceleration
				if y_slider < 0:
					y_slider = 0
			elif y_slider < 0:
				y_slider += max_speed / deceleration
				if y_slider > 0:
					y_slider = 0
		look_at(get_global_mouse_position())
	elif current_shape == Shape.SQUARE and charge_attack == true:
		velocity = (weapon.shape_direction.global_position - weapon.end_of_shape.global_position) * charge_speed
		x_slider = velocity.x
		y_slider = velocity.y
	velocity.x = x_slider
	velocity.y = y_slider
		
	velocity = move_and_slide(velocity, Vector2.ZERO)
	
	if Input.is_action_pressed("shoot"):
		if current_shape == Shape.TRIANGLE:
			weapon.shoot("Player")
		elif current_shape == Shape.SQUARE:
			if charge_time.is_stopped() == true and charging == false and charged == false:
				charge_time.start(0)
				print("I am charging")
				charging = true
	if Input.is_action_just_released("shoot"):
		if charging == true:
			charge_time.stop()
			print("I have stopped charging")
			charging = false
		elif charging == false and charged == true:
			charge_attack = true
			charged = false
			print("I have fired")
			charge_duration.start()
			
			
				
	if charge_attack == true:
		shape_selector.set_self_modulate(Color(10, 0, 0, 1))
	else:
		shape_selector.set_self_modulate(Color(0, 14, 14, 1))
	if invuln_timer.is_stopped() == false:
		shape_selector.set_self_modulate(Color(0, 0, 14, 1))
	if charged == true:
		shape_selector.set_self_modulate(Color(10, 0, 0, 1))
	
	if Input.is_action_just_pressed("switch_shape"):
		var new_shape = current_shape + 1
		new_shape = new_shape % 2
		set_shape(new_shape)

func set_shape(new_shape):
	if new_shape == current_shape:
		return
	if new_shape == Shape.TRIANGLE:
		max_speed = 800
		acceleration = 16
		deceleration = 32
		triangle_collision.disabled = false
		shape_selector.set_rotation_degrees(225)
		square_collision.disabled = true
		animation_player.play("switch_shape_2")
		
	elif new_shape == Shape.SQUARE:
		max_speed = 300
		acceleration = 8
		deceleration = 16
		triangle_collision.disabled = true
		square_collision.disabled = false
		shape_selector.set_rotation_degrees(90)
		animation_player.play("switch_shape")
	
	current_shape = new_shape

func handle_hit():
	if invuln_timer.is_stopped() == true:
		health_stat.health -= 20
		if health_stat.health <=0:
			var sound = "player_death"
			GlobalSignals.emit_signal("play_sound", sound)
			emit_signal("dead")
			queue_free()
			
		print("player hit!", health_stat.health)
		invuln_timer.start()
		$ShapeSelector.set_self_modulate(Color(10, 0, 0, 1))
		GlobalSignals.emit_signal("play_sound", "player_damage")
	
func handle_charge():
	if invuln_timer.is_stopped() == true:
		health_stat.health -= 40
		if health_stat.health <=0:
			var sound = "player_death"
			GlobalSignals.emit_signal("play_sound", sound)
			emit_signal("dead")
			queue_free()
		print("Player_Charged", health_stat.health)
		invuln_timer.start()
		$ShapeSelector.set_self_modulate(Color(10, 0, 0, 1))
		GlobalSignals.emit_signal("play_sound", "player_damage")


func _on_InvulnTimer_timeout():
	$ShapeSelector.set_self_modulate(Color(0, 11.63, 12.72, 1))


func _on_ChargeTime_timeout():
	if charged == false:
		print("I am charged")
		charged = true
		charging = false
		

func _on_ChargeDuration_timeout():
	charge_attack = false
	
func summon_shield():
		square_shield = pre_shield.instance()
		square_shield.position.x = 16
		add_child(square_shield)
		have_shield = true
		print("I have Shield")

func no_shield():
	have_shield = false
	shield_cooldown.start(0)
