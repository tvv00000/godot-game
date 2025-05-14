extends StaticBody3D

#võtab asju interactable area3d nodelt.
@onready var Interactable: Area3D = $Interactable
@export var interactName: String = ""

func _ready() -> void:
	#interactable scriptis interacatable skripti algus
	pass
	
func onInteract():
	print("siin kasfab lil")
	
