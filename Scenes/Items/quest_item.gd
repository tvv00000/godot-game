@tool
extends Area3D

@onready var mesh_instance_3d = $MeshInstance3D

@export var item_id: String = ""
@export var item_quantity: int = 1
@export var item_mesh: Mesh

func _ready():
	# Show mesh in the game
	if not Engine.is_editor_hint():
		if mesh_instance_3d and item_mesh:
			mesh_instance_3d.mesh = item_mesh

func _process(delta):
	# Show mesh in the engine (editor mode)
	if Engine.is_editor_hint():
		if mesh_instance_3d and item_mesh:
			mesh_instance_3d.mesh = item_mesh

func start_interact():
	print("I am an item!")


func _on_body_entered(body: Node3D) -> void:
	print("I am an item!")
