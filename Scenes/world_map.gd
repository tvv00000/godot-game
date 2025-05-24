extends StaticBody3D
@onready var Interactable: Area3D = $Interactable
@export var interactName: String = "Reisi Maailmas"

func _ready() -> void:
	#interactable scriptis interacatable skripti algus
	pass
	
func onInteract():
	print("interact toimib")
