extends Node2D


signal state_changed(new_state)


enum State{
	PATROL,
	ENGAGE,
	CHARGE
}


onready var player_detection_zone = $PlayerDetectionZone
onready var patrol_timer = $PatrolTimer
onready var charge_detection = $ChargeDetection


var current_state = -1 setget set_state
var actor = null
var player = null
var weapon = null
var shape = null
var speed = 200
var charge_speed = 600
var charging = false
var hit = false


var origin: Vector2 = Vector2.ZERO
var patrol_location = Vector2.ZERO
var patrol_location_reached = false
var actor_velocity = Vector2.ZERO


func _ready():
	set_state(State.PATROL)


func _physics_process(delta):
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				actor.move_and_slide(actor_velocity)
				actor.rotation = lerp(actor.rotation, actor.global_position.direction_to(patrol_location).angle(), 0.1)
				if actor.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					actor_velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if player != null and weapon != null and shape == "Triangle":
				var angle_to_player = actor.global_position.direction_to(player.global_position).angle()
				actor.rotation = lerp_angle(actor.rotation, angle_to_player, 0.1)
				if abs(actor.rotation - angle_to_player) < 0.1:
					weapon.shoot("Enemy")
		
		State.CHARGE:
			var angle_to_player = actor.global_position.direction_to(player.global_position).angle()
			if player != null and weapon != null and shape == "Square" and charging == false:
				actor.rotation = lerp_angle(actor.rotation, angle_to_player, 0.1)
				actor_velocity = global_position.direction_to(player.global_position) * speed
				if global_position.distance_to(player.position) < 200:
					actor_velocity = Vector2.ZERO
					actor.rotation = lerp_angle(actor.rotation, angle_to_player, 0.1)
					$ChargeTimer.start()
					charging = true
			elif player != null and weapon != null and shape == "Square" and charging == true and $ChargeDuration.is_stopped() == true:
				actor_velocity = Vector2.ZERO
				actor.rotation = lerp_angle(actor.rotation, angle_to_player, 0.5)
			if player != null and weapon != null and shape == "Square" and charging == true and $ChargeDuration.is_stopped() == false and $ChargeTimer.is_stopped() == true and hit == false:
					actor_velocity = global_position.direction_to(weapon.end_of_shape.global_position) * charge_speed
					
			else:
				pass
			actor.move_and_slide(actor_velocity)
		_:
			print("Error: found a state for our enemy that should not exist")

func initialize(actor, weapon, shape):
	self.actor = actor
	self.weapon = weapon
	self.shape = shape
	print(shape)


func set_state(new_state):
	if new_state == current_state:
		return
	
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
	
	
	current_state = new_state
	emit_signal("state_changed", current_state)

func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("player") and shape == "Triangle":
		set_state(State.ENGAGE)
		player = body
	elif body.is_in_group("player") and shape == "Square":
		set_state(State.CHARGE)
		player = body


func _on_PlayerDetectionZone_body_exited(body):
	if player and body == player:
		set_state(State.PATROL)
		player = null
		

func _on_PatrolTimer_timeout():
	var patrol_range = 50
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	actor_velocity = actor.global_position.direction_to(patrol_location) * 100
	
	

func _on_ChargeTimer_timeout():
	$ChargeDuration.start()



func _on_ChargeDuration_timeout():
	charging = false
	hit = false
	



func _on_ChargeDetection_body_entered(body):
	if body.has_method("handle_charge") and charging == true:
		body.handle_charge()
		hit = true
		actor_velocity = ((body.global_position - self.global_position) * -1) * 5
