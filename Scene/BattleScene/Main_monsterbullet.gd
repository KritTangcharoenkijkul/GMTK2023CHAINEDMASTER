extends Node3D

const SPEED = 40.0

@onready var mesh  = $MeshInstance3D
@onready var mesh2  = $MeshInstance3D2
@onready var mesh3  = $MeshInstance3D3
@onready var ray = $RayCast3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if ray.is_colliding():
		mesh.visible = false
		mesh2.visible = false
		mesh3.visible = false
		ray.enabled = false
		if ray.get_collider().is_in_group("enemy"):
			ray.get_collider().hit()
		if ray.get_collider().is_in_group("player"):
			ray.get_collider().hit()
		await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_timer_timeout():
	mesh.visible = false
	mesh2.visible = false
	mesh3.visible = false
	queue_free()
