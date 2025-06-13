@tool
extends Area3D

@onready var mesh_instance_3d = $MeshInstance3D

@export var item_id: String = ""
@export var item_quantity: int = 1
@export var item_mesh: Mesh
@export var inv_item: InvItem
var player = null


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



func _on_body_entered(body: CharacterBody3D) -> void:
	player = body
	player.collect(item_id, item_quantity)
	
	#Pickup popup tekst
	if player.popup:
		player.popup.item_pickup(global_transform.origin, inv_item.name)
		print("Item picked up "+item_id)

	queue_free()
