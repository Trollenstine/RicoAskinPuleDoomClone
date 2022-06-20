extends Spatial

var can_shoot = true
onready var  gunsprite = $CanvasLayer/Control/GunSprite
onready var spawn_location = $Position3D
onready var rocket

func launch_projectile():
	pass

func _process(delta):
	if Input.is_action_pressed("shoot") and can_shoot:
		gunsprite.play("shoot")
		launch_projectile()
		can_shoot = false
		yield(gunsprite,"animation_finished")
		can_shoot = true
		gunsprite.play("idle")
