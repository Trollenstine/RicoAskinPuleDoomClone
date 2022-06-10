extends Spatial

onready var gun_sprite = $CanvasLayer/Control/GunSprite
onready var gun_rays = $GunRays.get_children()
onready var flash = preload("res://MuzzleFlash.tscn")
var damage = 8
var can_shoot = true

func _ready():
	gun_sprite.play("idle")
	
func check_hit():
	for ray in gun_rays:
		if ray in gun_rays:
			if ray.is_colliding():
				if ray.get_collider().is_in_group("Enemy"):
					ray.get_collider().take_damage(damage)
	
func make_flash():
	var f = flash.instance()
	add_child(f)
	
func _process(delta):
	if Input.is_action_just_pressed("shoot") and can_shoot:
		gun_sprite.play("shoot")
		make_flash()
		check_hit()
		can_shoot = false
		
		yield (gun_sprite,"animation_finished")
		
		can_shoot = true
		gun_sprite.play("idle")
