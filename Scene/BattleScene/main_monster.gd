extends CharacterBody3D

var bullet = load("res://Scene/BattleScene/Main_monsterbullet.tscn")
var bullet2 = load("res://Scene/BattleScene/Main_monsterbulletpunch.tscn")
var instance
@onready var camera_mount = $camera_mount
@onready var gun_barrel = $PikachuHand/RayCast3D
const SPEED = 8.0
const JUMP_VELOCITY = 4.5

var sens_horizontal = 0.5
var sens_vertical = 0.5
var health = 20
var maxhealth = 20

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	if Input.is_action_just_pressed("mouse_left"):
		$ThunderCry.play()
		instance = bullet.instantiate()
		instance.position = gun_barrel.global_position
		instance.transform.basis = gun_barrel.global_transform.basis
		get_parent().add_child(instance)
		
		
	if Input.is_action_just_pressed("mouse_middle"):
		$CryCry.play()
	if Input.is_action_just_pressed("mouse_right"):
		instance = bullet2.instantiate()
		instance.position = gun_barrel.global_position
		instance.transform.basis = gun_barrel.global_transform.basis
		get_parent().add_child(instance)
		$AttackCry.play()
		
	if Input.is_action_just_pressed("Back_To_Menu"):
		get_tree().change_scene_to_file("res://Scene/BattleScene/you_win_screen.tscn")
		#get_tree().change_scene_to_file("res://Scene/MenuScreen/menu.tscn")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	

func _on_area_3d_player_body_part_hit(dam):
	health -= dam
	$HealthLevel.text = str(health) + "/"+ str(maxhealth)
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://Scene/BattleScene/you_lose_screen.tscn")
