extends Area2D


export var speed = 20


onready var kill_timer = $KillTimer
onready var sprite = $Sprite


var dying = false
var direction = Vector2.ZERO


func _ready():
	kill_timer.start()
	
	
func _physics_process(delta):
	if direction != Vector2.ZERO and dying == false:
		var velocity = direction * speed
		
		global_position += velocity
	elif dying == true:
		global_position += Vector2.ZERO

	
func set_direction(direction):
	self.direction = direction
	rotation += direction.angle()


func _on_KillTimer_timeout():
	queue_free()


func _on_Bullet_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
		sprite.play("Disintegrate")
		dying = true



func _on_Sprite_animation_finished():
	queue_free()
