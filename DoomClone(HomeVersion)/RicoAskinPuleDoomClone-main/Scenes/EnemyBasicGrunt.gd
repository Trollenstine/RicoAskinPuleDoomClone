extends KinematicBody

onready var nav = get_tree().get_nodes_in_group("NavMesh")[0]
onready var player = get_tree().get_nodes_in_group("Player")[0]

var path = [] #holds the path coordinates from the enemy to the player
var path_index = 0 #keeps track of which coords to go to
var speed = 10
var health = 70
var move = true
var damage = 8

var searching = false
var shooting = false
var dead = false
var hurt = false
onready var ray = $Visual

func _ready():
	pass

func take_damage(dmg_ammount):
	health -= dmg_ammount
	if health <= 0:
		death()
		return
	else:
		hurt = true
		$AnimatedSprite3D.play("hit")
		yield($AnimatedSprite3D,("animation_finished"))
		print("done")
		hurt = false
	
func _physics_process(delta):
	if dead:
		return
	look_at_player()
	if searching and not shooting and not hurt:
		if path_index < path.size():
			var direction = (path[path_index] - global_transform.origin)
			if direction.length() < 1:
				path_index += 1
			else:
				$AnimatedSprite3D.play("walking")
				move_and_slide(direction.normalized() * speed, Vector3.UP)
		else:
			find_path(player.global_transform.origin)
	else:
		if not shooting and not hurt:
			$AnimatedSprite3D.play("idle")


func look_at_player():
	ray.look_at(player.global_transform.origin, Vector3.UP)
	ray.rotation_degrees.x = 0
	if ray.is_colliding():
		if ray.get_collider().is_in_group("Player"):
			searching = true
		#	print("i see you")
				
		else:
			searching = false
			var check_near = $Aural.get_overlapping_bodies()
			for body in check_near:
				if body.is_in_group("Player"):
					searching = true
				

func find_path(target):
	path = nav.get_simple_path(global_transform.origin,target)
	path_index = 0
	
func death():
	dead = true
	#set_process(false)
	#set_physics_process(false)
	$CollisionShape.disabled = true
	if health < -20:
		$AnimatedSprite3D.play("explode")
	else:
		$AnimatedSprite3D.play("die")
	
func shoot():
	if searching and not dead and not shooting and not hurt:
		$AnimatedSprite3D.play("shoot")
		shooting = true
		yield($AnimatedSprite3D,"frame_changed")
		if ray.is_colliding():
			if ray.get_collider().is_in_group("Player"):
				PlayerStats.change_health(-damage)
		yield($AnimatedSprite3D,"animation_finished")
		shooting = false


func _on_Timer_timeout():
	find_path(player.global_transform.origin) 


func _on_Aural_body_entered(body):
	if body.is_in_group("Player"):
	#	print("I hear you")
		searching = true


func _on_Shooter_timeout():
	shoot()
