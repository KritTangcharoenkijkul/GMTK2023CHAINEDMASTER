extends CharacterBody3D
var player = null
@export var player_path : NodePath

var damage := 1
var health = 50
var maxhealth = 50

const SPEED = 4.5
const JUMP_VELOCITY = 4.5

var bullet = load("res://Scene/BattleScene/Main_monsterbullet.tscn")
var bullet2 = load("res://Scene/BattleScene/Main_monsterbulletpunch.tscn")
var instance
@onready var gun_barrel = $RivalHand/RayCast3D
@onready var nav_agent = $NavigationAgent3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	player = get_node(player_path)

func _physics_process(delta):
	velocity = Vector3.ZERO
	
	
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	look_at(Vector3(player.global_position.x, player.global_position.y, player.global_position.z), Vector3.UP)
	move_and_slide()
	
	
	


func _on_area_3d_body_part_hit(dam):
	health -= dam
	$HealthLevel.text = str(health) + "/"+ str(maxhealth)
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://Scene/BattleScene/you_win_screen.tscn")


func _on_timer_timeout():
	instance = bullet.instantiate()
	instance.position = gun_barrel.global_position
	instance.transform.basis = gun_barrel.global_transform.basis
	get_parent().add_child(instance)
