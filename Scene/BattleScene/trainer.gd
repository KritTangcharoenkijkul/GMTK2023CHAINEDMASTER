extends CharacterBody3D

var damage := 1
var health = 100
var maxhealth = 100

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	pass
	


func _on_area_3d_body_part_hit(dam):
	health -= dam
	$HealthLevel.text = str(health) + "/"+ str(maxhealth)
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://Scene/BattleScene/you_areFree_screen.tscn")
