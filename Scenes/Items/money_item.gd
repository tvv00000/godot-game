extends Area3D

@onready var mesh_instance_3d = $MeshInstance3D

@export var money_amount: int = 1
@export var money_mesh: Mesh

var player = null


func _ready():
	if mesh_instance_3d and money_mesh:
		mesh_instance_3d.mesh = money_mesh

func _on_body_entered(body: CharacterBody3D) -> void:
	player = body
	
	if player and player.has_method("add_money"):
		player.add_money(money_amount)
		print("Collected %d money." % money_amount)
		
	queue_free()
