extends Node2D
class_name Weapon

signal weapon_fired(bullet, location, direction)


export (PackedScene) var Bullet


onready var end_of_shape = $EndOfShape
onready var shape_direction = $ShapeDirection
onready var attack_cooldown = $AttackCooldown
onready var player_shoot_sound = $PlayerShootSound
onready var enemy_shoot_sound = $EnemyShootSound

func shoot(color = null):
	if attack_cooldown.is_stopped() and Bullet != null:
		var bullet_instance = Bullet.instance()
		if color == "Player":
			bullet_instance.set_modulate(Color(0, 10, 10, 1))
			attack_cooldown.set_wait_time(0.3)
			bullet_instance.set_collision_mask_bit(2, 4)
			player_shoot_sound.play()
		elif color == "Enemy":
			bullet_instance.set_modulate(Color(10, 0, 0, 1))
			bullet_instance.set_collision_mask_bit(1, 2)
			bullet_instance.speed = 10
			enemy_shoot_sound.play()
		var direction = (shape_direction.global_position - end_of_shape.global_position).normalized()
		GlobalSignals.emit_signal("bullet_fired", bullet_instance, end_of_shape.global_position, direction)
		attack_cooldown.start()
